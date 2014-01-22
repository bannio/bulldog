module ApplicationHelper
  def user_has_account?
    @has_account ||= current_user.account.present?
  end
end
