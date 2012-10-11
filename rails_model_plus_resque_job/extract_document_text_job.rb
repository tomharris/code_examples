class ExtractDocumentTextJob
  @queue = :application

  class << self
    def perform(attached_document_id)
      begin
        attached_document = AttachedDocument.unscoped.find(attached_document_id)
        file = attached_document.document.to_file
        file.close

        plain_text = \
          case File.extname(file.path)
          when '.docx'
            docx_to_txt(file.path)
          when '.doc'
            doc_to_txt(file.path)
          when '.xls'
            doc_to_txt(file.path)
          when '.rtf'
            doc_to_txt(file.path)
          when '.txt'
            anything_to_txt(file.path)
          else
            nil
          end

        AttachedDocument.unscoped.update_all(["plain_text = ?", plain_text], ["id = ?", attached_document.id])
      ensure
        #cleanup temp file created by paperclip's #to_file
        file.unlink if file.respond_to?(:unlink)
      end
    end

    private

    def docx_to_txt(filename)
      `unzip -p "#{filename}" | grep -a '<w:r' | LANG=C sed 's/<w:p[^<\/]*>/ /g' | LANG=C sed 's/<[^<]*>//g' | grep -v '^[[:space:]]*$' | LANG=C sed G`
    end

    def doc_to_txt(filename)
      `catdoc "#{filename}"`
    end

    def anything_to_txt(filename)
      `strings "#{filename}"`
    end
  end
end