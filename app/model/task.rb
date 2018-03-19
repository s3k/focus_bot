class Task < ActiveRecord::Base
  belongs_to :group

  scope :not_done, -> { where(done: [false, nil]) }
end
