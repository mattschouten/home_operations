class ChoresController < ApplicationController
    def create
        @chore_list = ChoreList.find(params[:chore_list_id])
        @chore = @chore_list.chores.create(chore_params)
        redirect_to chore_list_path(@chore_list)
    end

    def update
        @chore_list = ChoreList.find(params[:chore_list_id])
        @chore = Chore.find(params[:id])

        chore_is_done = params.key?("completed") && params["completed"].key?(@chore.id.to_s)
        @chore.update(is_done: chore_is_done)

        redirect_to chore_list_path(@chore_list)
    end

    private
        def chore_params
            params.require(:chore).permit(:name, :assigned_to, :is_done)
        end
end
