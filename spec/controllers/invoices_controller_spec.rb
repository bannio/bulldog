require 'rails_helper'

describe InvoicesController do

  login_user
  create_customer
  create_bill


  def valid_attributes
   { date:      Time.now,
    number:     "1",
   comment:     "My invoice",
   customer_id: @customer.id,
   account_id:  @account.id,
   total:       "0.0",
   include_vat: nil,
   include_bank: nil
   }
 end

  it "should have a current_user" do
    expect(subject.current_user).to_not be_nil
  end

  describe "GET #index" do
    it "returns http success even when no invoices" do
      get 'index'
      expect(response).to be_success
    end

    it "assigns all invoices as @invoices" do
      invoice = create(:invoice, valid_attributes)
      get :index, {}
      expect(assigns(:invoices)).to eq [invoice]
    end
  end

  describe "GET #show" do
    it "assigns the chosen invoice as @invoice" do
      invoice = create(:invoice, valid_attributes)
      get :show, params: {id: invoice.to_param}
      expect(assigns(:invoice)).to eq invoice
    end

    it "assigns the customer as @customer" do
      invoice = create(:invoice, valid_attributes)
      get :show, params: {id: invoice.to_param}
      expect(assigns(:customers)).to eq [@customer]
    end

    it "limits the customer choice to one" do
      invoice = create(:invoice, valid_attributes)
      get :show, params: {id: invoice.to_param}
      expect(assigns(:customers)).to eq [invoice.customer]
    end
  end

  describe "GET #new" do
    it "assigns a new invoice as @invoice" do
      get :new, {}
      expect(assigns(:invoice)).to be_a_new(Invoice)
    end
  end

  describe "POST #create" do
    describe "with valid attributes" do
      it "creates a new invoice" do
        expect {
          post :create, params: {invoice: valid_attributes}
        }.to change(Invoice, :count).by(1)
      end

      it "assigns the newly created invoice as @invoice" do
        post :create, params: {invoice: valid_attributes}
        expect(assigns(:invoice)).to be_a(Invoice)
        expect(assigns(:invoice)).to be_persisted
      end

      it "displays the show view for checking of bills" do
        post :create, params: {invoice: valid_attributes}
        expect(response).to redirect_to(edit_invoice_path(Invoice.last))
      end

      it "updates associated bills" do
        customer = create(:customer, account_id: @account.id)
        bill1 = create(:bill, account_id: @account.id, customer_id: customer.id)
        bill2 = create(:bill, account_id: @account.id, customer_id: customer.id)
        post :create, params: {invoice: valid_attributes.merge(customer_id: customer.id)}
        expect(bill1.reload.invoice_id).to eq Invoice.last.id
        expect(bill2.reload.invoice_id).to eq Invoice.last.id

      end

      it "does not create if there are no bills" do
        customer = create(:customer, account_id: @account.id)
        expect {
          post :create, params: {invoice: valid_attributes.merge(customer_id: customer.id)}
        }.to_not change(Invoice, :count)
      end

      it "sets defaults for printing" do
        @account.setting.update_attribute(:include_vat, true)
        post :create, params: {invoice: valid_attributes}
        expect(Invoice.last.include_vat).to be_truthy
        expect(Invoice.last.include_bank).to be_falsey
      end

      it "sets defaults for printing" do
        @account.setting.update_attribute(:include_bank, true)
        post :create, params: {invoice: valid_attributes}
        expect(Invoice.last.include_vat).to be_falsey
        expect(Invoice.last.include_bank).to be_truthy
      end
    end

    describe "with invalid attributes" do
      it "renders the new template" do
        allow(Invoice).to receive(:save) {false}
        # Invoice.any_instance.stub(:save).and_return(false)
        post :create, params: {invoice: valid_attributes.merge(customer_id: nil)}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do

    it "assigns the requested invoice as @invoice" do
      invoice = create(:invoice, valid_attributes)
      get :edit, params: {id: invoice.to_param}
      expect(assigns(:invoice)).to eq(invoice)
    end

    it "does not assign another users invoice" do
      invoice = create(:invoice, valid_attributes.merge(account_id: @account.id + 1))
      get :edit, params: {id: invoice.to_param}
      expect(response).to redirect_to home_path
    end
  end

  describe "PATCH #update" do
    before :each do
      @invoice = create(:invoice, valid_attributes)
    end
    context "with valid attributes" do
      it "updates the requested invoice" do
        patch :update, params: {id: @invoice, invoice: attributes_for(:invoice, comment: "changed comment")}
        @invoice.reload
        expect(@invoice.comment).to eq "changed comment"
      end
      it "assigns the invoice as @invoice" do
        patch :update, params: {id: @invoice, invoice: attributes_for(:invoice)}
        expect(assigns(:invoice)).to eq @invoice
      end
      it "redirects to invoice show " do
        patch :update, params: {id: @invoice, invoice: attributes_for(:invoice)}
        expect(response).to redirect_to @invoice
      end

      it "limits the customer choice to one" do
        patch :update, params: {id: @invoice, invoice: attributes_for(:invoice)}
        expect(assigns(:customers)).to eq [@invoice.customer]
      end

      it "recalculates the total" do
        customer = create(:customer, account_id: @account.id)
        bill = create(:bill, account_id: @account.id, customer_id: customer.id, amount: "10")
        post :create, params: {invoice: valid_attributes.merge(customer_id: customer.id)}
        invoice = Invoice.last
        id = invoice.id
        expect(invoice.total).to eq 10
        bill.destroy
        patch :update, params: {id: id, invoice: {comment: "updated"}}
        invoice = Invoice.find(id)
        expect(invoice.total).to eq 0
      end

    end
    context "with invalid attributes" do
      it "re-renders the edit template" do
        patch :update, params: {id: @invoice, invoice: attributes_for(:invoice, date: "")}
        expect(response).to render_template 'edit'
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @invoice = create(:invoice, valid_attributes)
    end
    it "destroys the requested invoice" do
      expect{
        delete :destroy, params: {id: @invoice.to_param}
      }.to change(Invoice, :count).by(-1)
    end
    it "redirects to the invoice index" do
      delete :destroy, params: {id: @invoice.to_param}
      expect(response).to redirect_to invoices_path
    end
  end

end
