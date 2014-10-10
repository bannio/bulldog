class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    [:from_date, :to_date, :account_id, :customer_id, :supplier_id, :category_id]
  end

  # def index?    ; user.account.active?                  ; end
  # def show?     ; user.account.active?                  ; end
  def create?   ; user.account.active?                  ; end
  def new?      ; create?                               ; end
  # def update?   ; user.account.active?                  ; end
  # def edit?     ; update?                               ; end
  # def destroy?  ; user.account.active?                  ; end

end