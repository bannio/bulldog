class CustomerPolicy < ApplicationPolicy
  class Scope < Scope
  # class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    [:account_id, :name, :address, :postcode, :is_default]
  end

  def index?    ; user.account.active?                  ; end
  def show?     ; user.account.active?                  ; end
  def create?   ; user.account.active?                  ; end
  def new?      ; create?                               ; end
  def update?   ; user.account.active?                  ; end
  def edit?     ; update?                               ; end
  def destroy?  ; user.account.active?                  ; end

end
