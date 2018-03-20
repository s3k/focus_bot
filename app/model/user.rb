class User < ActiveRecord::Base
  has_and_belongs_to_many :groups

  def tasks
    current_group.tasks
  end

  private

  def current_group
    if current_group_id
      groups.where(id: current_group_id).first
    else
      init_default_group
    end
  end

  def init_default_group
    if default_group_id.blank?
      group = self.groups.create(name: :default)
      self.update_attributes(default_group_id: group.id)

      return group
    end

    groups.where(id: default_group_id).first
  end
end
