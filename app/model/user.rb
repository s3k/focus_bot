class User < ActiveRecord::Base
  has_and_belongs_to_many :groups

  def tasks
    current_group.tasks
  end

  def current_group
    if current_group_id && current_group_id != 0
      groups.find_by(id: current_group_id)
    else
      init_default_group
    end
  end

  def default_group
    groups.find_by(id: current_group_id)
  end

  private

  def init_default_group
    if default_group_id.blank?
      group = self.groups.create(name: :default)
      self.update_attributes(default_group_id: group.id)

      return group
    end

    groups.find_by(id: default_group_id)
  end
end
