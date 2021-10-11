require 'rails_helper'

RSpec.describe Chore, :type => :model do
    it "requires a name at least two characters long" do
        chore = Chore.new(name: nil, assigned_to: 'x')
        chore.validate
        expect(chore).to_not be_valid
        expect(chore.errors[:name]).to include("can't be blank")

        chore.name= 'x'
        chore.validate
        expect(chore).to_not be_valid
        expect(chore.errors[:name]).to include("is too short (minimum is 2 characters)")
    end

    it "must be assigned" do
        chore = Chore.new(name: "do something", assigned_to: nil)
        chore.validate
        expect(chore).to_not be_valid
        expect(chore.errors[:assigned_to]).to include("can't be blank")
    end

    it "must belong to a chore list" do
        chore = Chore.new(name: "fold your socks", assigned_to: "you", chore_list: nil)
        chore.validate
        expect(chore).to_not be_valid
        expect(chore.errors[:chore_list]).to include("must exist")
    end

    it "can be done" do
        chore_list = ChoreList.new(date: Time.now)
        chore = Chore.new(name: "iron your socks", assigned_to: "you", chore_list: chore_list)

        expect(chore.is_done).to be_falsey
        chore.is_done = true
        expect(chore.is_done).to be true

    end
end