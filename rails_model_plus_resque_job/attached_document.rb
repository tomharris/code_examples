class AttachedDocument < ActiveRecord::Base
  attr_accessor :file_name_to_use_instead_of_the_one_assigned_to_document
  attr_protected :user_id

  belongs_to :user
  has_attached_file :document, MyApp::Application.config.custom.paperclip_document_config
  has_attached_file :shadowed_pdf_document, MyApp::Application.config.custom.paperclip_document_config
  alias_method :raw_shadowed_pdf_document, :shadowed_pdf_document

  validates_presence_of :user
  validates_presence_of :name
  validate :presence_of_document

  before_validation :assign_default_name
  before_save :rename_document
  before_save :guess_content_type
  after_save :queue_shadow_pdf_image_render
  after_save :queue_text_extraction

  default_scope where("category <> 'special'")

  state_machine :initial => :public do
    event :archive do
      transition :public => :archived
    end
    event :publish do
      transition :archived => :public
    end
  end

  def shadowed_pdf_document
    if self.pdf?
      self.document
    else
      self.raw_shadowed_pdf_document
    end
  end

  def resume?
    self.category == 'resume'
  end

  def file_type
    case self.document_content_type
    when 'application/pdf'
      'pdf'
    else
      'word'
    end
  end

  def pdf?
    self.file_type == 'pdf'
  end

  def document_extention
    File.extname(self.document_file_name || '')
  end

  def shadowed_pdf_image_file_name
    "#{self.shadowed_pdf_document.original_filename}_rendered.jpg" if self.shadowed_pdf_document.file?
  end

  protected

  def presence_of_document
    if !self.document.file?
      errors.add(:document, :is_required)
    end
  end

  def assign_default_name
    if self.name.blank?
      self.name = self.document.original_filename
    end
  end

  def guess_content_type
    self.document_content_type = File.mime_type?(self.document_file_name)
  end

  def rename_document
    if self.file_name_to_use_instead_of_the_one_assigned_to_document.present?
      self.document.instance_write(:file_name, self.file_name_to_use_instead_of_the_one_assigned_to_document)
    end
  end

  def queue_shadow_pdf_image_render
    Resque.enqueue(RenderShadowedPdfDocumentJob, self.id)
  end

  def queue_text_extraction
    Resque.enqueue(ExtractDocumentTextJob, self.id)
  end
end
