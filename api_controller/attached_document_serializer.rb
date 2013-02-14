class AttachedDocumentSerializer < ActiveModel::Serializer
  attributes :name, :category, :shadowed_pdf_image_url

  private

  def attributes
    hash = super
    hash.merge!(virtual_attributes)
    hash
  end

  def virtual_attributes
    {
      :document_url => document_url
    }
  end

  def document_url
    attached_document.document.expiring_url(1.hour)
  end
end