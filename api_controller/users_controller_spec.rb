describe "#documents" do

  before(:all) do
    Object.pathy! # the fantastic pathy gem for easily testing json responses
  end

  before(:each) do
    @user = Factory(:user)
    @attached_document = AttachedDocument.create(
      :user => @user,
      :category => 'resume',
      :name => 'test',
      :document_file_name => "resume.doc",
      :document_content_type => "application/msword",
      :document_file_size => 300_000,
      :shadowed_pdf_document_file_name => "resume.pdf",
      :shadowed_pdf_document_content_type => "application/pdf",
      :shadowed_pdf_document_file_size => 300_000
    )
  end

  def do_get
    get :documents, :format => 'json', :id => @user.id, :token => generate_token
    @parsed_json = JSON.parse(response.body)
  end

  it "should return 403 when the token isn't given" do
    get :documents, :format => 'json', :id => @user.id
    response.code.should == '403'
  end

  it "should return 403 when the token is invalid" do
    get :documents, :format => 'json', :id => @user.id, :token => 'not_a_valid_token'
    response.code.should == '403'
  end

  it "should have the document's name" do
    do_get
    @parsed_json.at_json_path('attached_documents.0.name').should == @attached_document.name
  end

  it "should have the document's category" do
    do_get
    @parsed_json.at_json_path('attached_documents.0.category').should == @attached_document.category
  end

  it "should have the document's document_url" do
    do_get
    @parsed_json.at_json_path('attached_documents.0.document_url').should == @attached_document.document.url
  end

  it "should have the document's shadowed image url" do
    do_get
    @parsed_json.at_json_path('attached_documents.0.shadowed_pdf_image_url').should == @attached_document.shadowed_pdf_image_url
  end

end