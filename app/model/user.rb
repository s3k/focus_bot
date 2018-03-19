class User < ActiveRecord::Base
  has_and_belongs_to_many :groups

  def tasks
    groups.where(id: current_group_id).first.tasks
  end
end
