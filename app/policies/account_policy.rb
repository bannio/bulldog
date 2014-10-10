class AccountPolicy < ApplicationPolicy

  def initialize(user = User.new, record)
    @user = user
    @record = record
  end
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def permitted_attributes
    [:name, :address, :postcode,
      :include_bank, :bank_account_name, :bank_name, :bank_address,
      :bank_account_no, :bank_sort, :bank_bic, :bank_iban, :invoice_heading,
      :vat_enabled, :plan_id, :email, :stripe_customer_token, :user_id,
      :stripe_card_token, :title, :price, :interval, :card_last4,
      :card_expiration, :next_invoice, :date_reminded, :mail_list]
  end

  # def index?    ; user.account.active?                  ; end
  def show?        ; true                                  ; end
  def create?      ; true                                  ; end
  def new?         ; true                                  ; end
  def update?      ; true                                  ; end
  def edit?        ; true                                  ; end
  def cancel?      ; user.account.active?                  ; end
  def new_card?    ; true                                  ; end
  def update_card? ; true                                  ; end
  # def destroy?  ; user.account.active?                  ; end

end