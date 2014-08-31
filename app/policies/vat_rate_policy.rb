class VatRatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    # if user.admin? || user.owner_of?(vat_rate)
      [:account_id, :name, :rate, :active]
    # end
  end

  def index?    ; user.account.business?                  ; end
  # def show?     ; user.account.business?                  ; end
  def create?   ; user.account.business?                  ; end
  def new?      ; create?                                 ; end
  def update?   ; user.account.business?                  ; end
  def edit?     ; update?                                 ; end
  def destroy?  ; user.account.business?                  ; end

end