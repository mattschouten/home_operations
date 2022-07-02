class ChoreListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chore_lists = current_user&.family&.chore_lists
  end

  def show
    @chore_list = ChoreList.find(params[:id])
    return head(:forbidden) unless current_user&.family == @chore_list&.family

    @chores_by_person = chores_by_person

    if session.key? :last_assigned_to
      @default_assigned_to = session[:last_assigned_to]
      session.delete :last_assigned_to
    end
  end

  def new
    @chore_list = ChoreList.new
  end

  def create
    return head(:forbidden) unless current_user&.role_owner?

    @chore_list = ChoreList.new(chore_list_params.merge({ family: current_user.family }))

    if @chore_list.save
      @chore_list.add_everyday_chores(current_user.family)
      redirect_to @chore_list
    else
      render :new
    end
  end

  def carryover
    redirect_to chore_list_path(id: params[:id]) and return unless current_user&.role_owner?

    source_list = ChoreList.find(params[:id])
    return head(:forbidden) unless current_user&.family == source_list&.family

    @chore_list = ChoreList.new_carry_over(source_list)
    if @chore_list.save
      redirect_to @chore_list
    else
      render :new
    end
  end

  def today
    today_in_zone = Time.current.in_time_zone('America/Chicago').to_date
    @chore_list = ChoreList.find_by(date: today_in_zone, family: current_user.family)

    if @chore_list.nil?
      redirect_to chore_lists_path
    else
      @chores_by_person = chores_by_person
      render :show
    end
  end

  private
    def chore_list_params
      params.require(:chore_list).permit(:date)
    end

    def chores_by_person
      @chore_list.chores.group_by { |chore| chore.assigned_to }
    end
end
