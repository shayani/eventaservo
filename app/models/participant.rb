class Participant < ApplicationRecord
  self.table_name = 'participants'

  belongs_to :event
  belongs_to :user

  scope :publikaj, -> { where(public: true) }
end
