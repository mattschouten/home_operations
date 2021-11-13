class ChoreList < ApplicationRecord
  belongs_to :family
  has_many :chores

  validates :date, presence: true

  def self.new_carry_over(source_list)
    # TODO: See if there's a list to carry over from
    new_list = ChoreList.create!(date: source_list.date + 1, family: source_list.family)
    source_list.chores.where(is_done: [false, nil]).each do |chore|
      carried_over = Chore.create!(
        name: "*#{chore.name}",
        assigned_to: chore.assigned_to,
        chore_list: new_list,
        is_done: false
      )
    end

    new_list
  end
end
