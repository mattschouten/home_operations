class Family < ApplicationRecord
  has_many :chore_lists

  has_many :users

  has_many :everyday_chores
end
