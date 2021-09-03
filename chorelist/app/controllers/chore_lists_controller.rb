class ChoreListsController < ApplicationController
  def index
    @chore_lists = ChoreList.all
  end

  def show
    @chore_list = ChoreList.find(params[:id])
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
