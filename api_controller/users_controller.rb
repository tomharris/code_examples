class UsersController < ApiController
  before_filter :authenticate #authenticate the user for this session

  def documents
    @user = User.find(params[:id])
    @attached_documents = AttachedDocument
      .unscoped
      .with_state('public')
      .where(:user_id => @user.id)
      .paginate(:page => params[:page], :per_page => MyApp::Application.config.custom.default_per_page_pagination)

    respond_with do |format|
      format.json { render :json => @attached_documents, :root => :attached_documents }
    end
  end
end