class EverydayChore < ApplicationRecord
  belongs_to :family

  validates :name, presence: true, length: { minimum: 2 }
  validates :assigned_to, presence: true, length: { minimum: 2 }
end
