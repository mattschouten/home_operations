class ChoresController < ApplicationController
    def create
        @chore_list = ChoreList.find(params[:chore_list_id])
        @chore = @chore_list.chores.create(chore_params)
        redirect_to chore_list_path(@chore_list)
    end

    private
        def chore_params
            params.require(:chore).permit(:name, :assigned_to, :is_done)
        end
end
