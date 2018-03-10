class Task < ActiveRecord::Base
  belongs_to :user
  # belongs_to :goal

  scope :not_done, -> { where(done: [false, nil]) }
end
