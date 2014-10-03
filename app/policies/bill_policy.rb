class BillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    # if user.admin? || user.owner_of?(vat_rate)
      [:account_id, :customer_id, :supplier_id,
       :date, :category_id, :description, :amount,
       :new_customer, :new_supplier, :new_category,
       :vat_rate_id, :vat]
    # end
  end

  def index?    ; user.account.active?                  ; end
  def show?     ; user.account.active?                  ; end
  def create?   ; user.account.active?                  ; end
  def new?      ; create?                               ; end
  def update?   ; user.account.active?                  ; end
  def edit?     ; update?                               ; end
  def destroy?  ; user.account.active?                  ; end

end