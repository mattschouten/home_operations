class ChoresController < ApplicationController
  def create
    @chore_list = ChoreList.find(params[:chore_list_id])
    return head(:forbidden) unless current_user&.family == @chore_list&.family

    if current_user.role_owner?
      @chore = @chore_list.chores.create(chore_params)
      session[:last_assigned_to] = @chore.assigned_to
    end

    redirect_to chore_list_path(@chore_list)
  end

  def update
    @chore_list = ChoreList.find(params[:chore_list_id])
    return head(:forbidden) unless current_user&.family == @chore_list&.family

    @chore = Chore.find(params[:id])

    chore_is_done = params.key?('completed') && params['completed'].key?(@chore.id.to_s)
    @chore.update(is_done: chore_is_done)

    if previous_path
      redirect_to previous_path
    else
      redirect_to chore_list_path(@chore_list)
    end
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :assigned_to, :is_done)
  end
end
