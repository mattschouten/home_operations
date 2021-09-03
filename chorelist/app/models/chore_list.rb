class ChoreList < ApplicationRecord
    has_many :chores

    validates :date, presence: true
end
