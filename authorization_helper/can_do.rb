# This predates the wonderful CanCan gem from Ryan Bates. My requirements were very simple and this has served me well.

module CanDo
  extend ActiveSupport::Concern

  included do
    helper_method :i_can_read?
    helper_method :i_can_create?
    helper_method :i_can_edit?
    helper_method :i_can_delete?

    hide_action :i_can_read?, :i_can_create?, :i_can_edit?, :i_can_delete?
  end

  def i_can_read?(thing)
    thing.readable_by?(current_user)
  end

  def i_can_create?(klass)
    klass.creatable_by?(current_user)
  end

  def i_can_edit?(thing)
    thing.editable_by?(current_user)
  end

  def i_can_delete?(thing)
    thing.deletable_by?(current_user)
  end
end