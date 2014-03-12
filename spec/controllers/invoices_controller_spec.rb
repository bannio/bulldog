require 'spec_helper'

describe InvoicesController do
  login_user
  create_account
  create_customer 
  create_bill

  def valid_attributes
   { date:      Time.now,  
    number:     "1",
   comment:     "My invoice", 
   customer_id: @customer.id,
   account_id:  @account.id,
   total:       "0.0"
   }
 end

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "GET #index" do
    it "returns http success even when no invoices" do
      get 'index'
      response.should be_success
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
      get :show, {id: invoice.to_param}
      assigns(:invoice).should eq invoice
    end

    it "assigns the customer as @customer" do
      invoice = create(:invoice, valid_attributes)
      get :show, {id: invoice.to_param}
      assigns(:customers).should eq [@customer]
    end

    it "limits the customer choice to one" do
      invoice = create(:invoice, valid_attributes)
      get :show, {id: invoice.to_param}
      expect(assigns(:customers)).to eq [invoice.customer]
    end
  end

  describe "GET #new" do
    it "assigns a new invoice as @invoice" do
      get :new, {}
      assigns(:invoice).should be_a_new(Invoice)
    end
  end

  describe "POST #create" do
    describe "with valid attributes" do
      it "creates a new invoice" do
        expect {
          post :create, {invoice: valid_attributes}
        }.to change(Invoice, :count).by(1)
      end

      it "assigns the newly created invoice as @invoice" do
        post :create, {invoice: valid_attributes}
        assigns(:invoice).should be_a(Invoice)
        assigns(:invoice).should be_persisted
      end

      it "displays the show view for checking of bills" do
        post :create, {invoice: valid_attributes}
        response.should redirect_to(invoice_path(Invoice.last))
      end

      it "updates associated bills" do
        customer = create(:customer, account_id: @account.id)
        bill1 = create(:bill, account_id: @account.id, customer_id: customer.id)
        bill2 = create(:bill, account_id: @account.id, customer_id: customer.id)
        post :create, {invoice: valid_attributes.merge(customer_id: customer.id)}
        expect(bill1.reload.invoice_id).to eq Invoice.last.id
        expect(bill2.reload.invoice_id).to eq Invoice.last.id

      end

      it "does not create if there are no bills" do
        customer = create(:customer, account_id: @account.id)
        expect {
          post :create, {invoice: valid_attributes.merge(customer_id: customer.id)}
        }.to_not change(Invoice, :count)
      end
    end

    describe "with invalid attributes" do
      it "renders the new template" do
        Invoice.any_instance.stub(:save).and_return(false)
        post :create, {invoice: valid_attributes}
        response.should render_template('new')
      end
    end
  end

  describe "GET #edit" do

    it "assigns the requested invoice as @invoice" do
      invoice = create(:invoice, valid_attributes)
      get :edit, id: invoice.to_param
      assigns(:invoice).should eq(invoice)
    end 

    it "does not assign another users invoice" do
      invoice = create(:invoice, valid_attributes.merge(account_id: @account.id + 1))
      get :edit, id: invoice.to_param
      expect(response).to redirect_to home_path
    end
  end

  describe "PATCH #update" do
    before :each do
      @invoice = create(:invoice, valid_attributes)
    end
    context "with valid attributes" do
      it "updates the requested invoice" do
        patch :update, id: @invoice, invoice: attributes_for(:invoice, comment: "changed comment")
        @invoice.reload
        expect(@invoice.comment).to eq "changed comment"
      end
      it "assigns the invoice as @invoice" do
        patch :update, id: @invoice, invoice: attributes_for(:invoice)
        expect(assigns(:invoice)).to eq @invoice
      end
      it "redirects to invoice show " do
        patch :update, id: @invoice, invoice: attributes_for(:invoice)
        expect(response).to redirect_to @invoice
      end

      it "limits the customer choice to one" do
        patch :update, id: @invoice, invoice: attributes_for(:invoice)
        expect(assigns(:customers)).to eq [@invoice.customer]
      end

      it "recalculates the total" do
        customer = create(:customer, account_id: @account.id)
        bill = create(:bill, account_id: @account.id, customer_id: customer.id, amount: "10")
        post :create, {invoice: valid_attributes.merge(customer_id: customer.id)}
        invoice = Invoice.last
        id = invoice.id
        expect(invoice.total).to eq 10
        bill.destroy
        patch :update, id: id, invoice: {comment: "updated"}
        invoice = Invoice.find(id)
        expect(invoice.total).to eq 0
      end

    end
    context "with invalid attributes" do
      it "re-renders the edit template" do
        patch :update, id: @invoice, invoice: attributes_for(:invoice, date: "")
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
        delete :destroy, id: @invoice.to_param
      }.to change(Invoice, :count).by(-1)
    end
    it "redirects to the invoice index" do
      delete :destroy, id: @invoice.to_param
      expect(response).to redirect_to invoices_path
    end
  end

end
