class Chore < ApplicationRecord
  belongs_to :chore_list

  validates :name, presence: true, length: { minimum: 2 }
  validates :assigned_to, presence: true
end
