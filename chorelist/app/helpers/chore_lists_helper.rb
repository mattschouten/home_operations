module ChoreListsHelper
  def show_add_chore_widget?
    current_user.role_owner?
  end
end
