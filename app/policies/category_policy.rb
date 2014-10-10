class CategoryPolicy < ApplicationPolicy
  # class Scope < Struct.new(:user, :scope)
  class Scope < Scope
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    [:name]
  end

  def index?    ; user.account.active?                  ; end
  # def show?     ; user.account.active?                  ; end
  # def create?   ; user.account.active?                  ; end
  # def new?      ; create?                               ; end
  def update?   ; user.account.active?                  ; end
  def edit?     ; update?                               ; end
  # def destroy?  ; user.account.active?                  ; end

end