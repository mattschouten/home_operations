require 'rails_helper'

RSpec.describe "Chore Lists", :type => :request do

    describe "logged-out user behavior" do
        it "should redirect a request for chore lists to the main page" do
            get chore_lists_path
            expect(response).to redirect_to(root_path)
        end

        it "should redirect a request for a chore list to the main page" do
            get chore_list_path(id: 1)
            expect(response).to redirect_to(root_path)
        end
    end

    describe "logged-in user behavior" do
        it "should do some stuff I suppose"
    end

end