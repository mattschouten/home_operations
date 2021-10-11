class ChoreListsController < ApplicationController
  def index
    @chore_lists = ChoreList.all
  end

  def show
    @chore_list = ChoreList.find(params[:id])
    @chores_by_person = @chore_list.chores.group_by { |chore| chore.assigned_to }

    if session.key? :last_assigned_to
      @default_assigned_to = session[:last_assigned_to]
      session.delete :last_assigned_to
    end
  end

  def new
    @chore_list = ChoreList.new
  end

  def create
    @chore_list = ChoreList.new(chore_list_params)

    if @chore_list.save
      redirect_to @chore_list
    else
      render :new
    end
  end

  private
    def chore_list_params
      params.require(:chore_list).permit(:date)
    end
end
