class EverydayChoresController < ApplicationController
  def index
    @everyday_chores = current_user&.family&.everyday_chores
  end

  def show
    return head(:forbidden) unless current_user.role_owner?
    @everyday_chore = EverydayChore.find(params[:id])
    return head(:forbidden) unless current_user&.family == @everyday_chore&.family
  end

  def new
    @everyday_chore = EverydayChore.new
  end

  def create
    return head(:forbidden) unless current_user.role_owner?

    @everyday_chore = EverydayChore.create(everyday_chore_params)
    @everyday_chore.family = current_user.family
    if @everyday_chore.save
      redirect_to everyday_chore_path(@everyday_chore.id)
    else
      render :new
    end
  end

  def update
    return head(:forbidden) unless current_user.role_owner?

    @everyday_chore = EverydayChore.find(params[:id])
    return head(:forbidden) unless current_user&.family == @everyday_chore&.family

    if @everyday_chore.update(everyday_chore_params)
      redirect_to everyday_chore_path(@everyday_chore.id)
    else
      render :update
    end
  end

  def destroy
    return head(:forbidden) unless current_user.role_owner?

    everyday_chore = EverydayChore.find(params[:id])

    return head(:forbidden) unless current_user&.family == everyday_chore&.family

    everyday_chore.destroy!
    redirect_to everyday_chores_path
  end

  private

  def everyday_chore_params
    params.require(:everyday_chore).permit(:name, :assigned_to)
  end
end
