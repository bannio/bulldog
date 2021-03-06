class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    [:date, :customer_id, :comment, :number, :account_id,
    :total, :new_header, :header_id, :include_bank, :include_vat]
    # :from_date, :to_date, :inv_customer_id, :search]
  end

  def index?    ; user.account.active?                  ; end
  def show?     ; user.account.active?                  ; end
  def create?   ; user.account.active?                  ; end
  def new?      ; create?                               ; end
  def update?   ; user.account.active?                  ; end
  def edit?     ; update?                               ; end
  def destroy?  ; user.account.active?                  ; end

end