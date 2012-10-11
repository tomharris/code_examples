class User < ActiveRecord::Base

  def readable_by?(user)
    if user and user.admin?
      true
    elsif user == self
      true
    else
      false
    end
  end

  def editable_by?(user)
    user == self
  end

  def deletable_by?(user)
    user == self
  end

  def self.creatable_by?(user)
    true
  end
end