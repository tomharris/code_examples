class UsersController < ApplicationController
  include CanDo

  def show
    @user = User.find(params[:id])
    render_forbidden and return unless i_can_read?(@user)
  end
end