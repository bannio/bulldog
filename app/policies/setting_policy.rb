class SettingPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(account_id: user.account.id)
    end
  end

  def permitted_attributes
    [:account_id, :name, :address, :postcode,
      :bank_account_name, :bank_name, :bank_address,
      :bank_account_no, :bank_sort, :bank_bic, :bank_iban, :vat_reg_no,
      :include_vat, :include_bank, :telephone, :email, :logo]
  end

  def index?    ; user.account.active?                  ; end
  def show?     ; user.account.active?                  ; end
  # def create?   ; user.account.active?                  ; end
  # def new?      ; create?                               ; end
  def update?   ; user.account.active?                  ; end
  def edit?     ; update?                               ; end
  # def destroy?  ; user.account.active?                  ; end

end