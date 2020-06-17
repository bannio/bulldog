require 'rails_helper'

describe CustomersController do

  login_user

  def valid_attributes
   { name: "A Customer",
   address: "",
   postcode: "",
   account_id: @account.id
   }
 end

  it "should have a current_user" do
    expect(subject.current_user).to_not be_nil
  end

  describe "GET 'index'" do
    it "returns http success even when no customers" do
      get 'index'
      expect(response).to be_successful
    end
  end

 describe "GET index" do
   it "assigns all customers as @customers" do
     customer = Customer.create! valid_attributes
     get :index, {}
     expect(assigns(:customers)).to eq([customer])
   end
 end

 describe "GET index" do
   it "assigns only customers belonging to current account" do
     customer = Customer.create! valid_attributes
     customer2 = Customer.create! valid_attributes.merge(account_id: @account.id + 1)
     get :index, {}
     expect(assigns(:customers)).to eq([customer])
   end
 end


 describe "GET new" do
   it "assigns a new customer as @customer" do
     get :new, {}
     expect(assigns(:customer)).to be_a_new(Customer)
   end
 end

 describe "GET edit" do
   it "assigns the requested customer as @customer" do
     customer = Customer.create! valid_attributes
     get :edit, params: {:id => customer.to_param}
     expect(assigns(:customer)).to eq(customer)
   end
 end

 describe "GET edit" do
   it "does not assign another account's customer" do
     customer = Customer.create! valid_attributes.merge(account_id: @account.id + 1)
     get :edit, params: {:id => customer.to_param}
     expect(assigns(:customer)).to eq(nil)
   end
 end

 describe "PATCH #update" do

  before :each do
    @customer = Customer.create! valid_attributes
  end
   context "with valid attributes" do
     it "updates the requested customer" do
       patch :update, params: {id: @customer, customer: valid_attributes}
       expect(assigns(:customer)).to eq @customer
     end
   end

   context "with invalid attributes" do
     it "re-render edit" do
       patch :update, params: {id: @customer, customer: {name: ""}}
       expect(response).to render_template 'edit'
     end

     it "rejects someone else's customer" do
       customer = Customer.create! valid_attributes.merge(account_id: @account.id + 1)
       patch :update, params: {id: customer, customer: valid_attributes.merge(account_id: @account.id + 1)}
       expect(response).to redirect_to home_path
     end
   end
 end

 describe "POST create" do
   context "with valid params" do
     it "creates a new Customer" do
       expect {
         post :create, params: {:customer => valid_attributes}
       }.to change(Customer, :count).by(1)
     end

     it "assigns a newly created customer as @customer" do
       post :create, params: {:customer => valid_attributes}
       expect(assigns(:customer)).to be_a(Customer)
       expect(assigns(:customer)).to be_persisted
     end

     it "redirects to the customers index" do
       post :create, params: {:customer => valid_attributes}
       expect(response).to redirect_to(customers_url)
     end
   end

   context "with invalid params" do
     it "assigns a newly created but unsaved customer as @customer" do
       allow_any_instance_of(Customer).to receive(:save).and_return(false)
       post :create, params: {:customer => { name: "" }}
       expect(assigns(:customer)).to be_a_new(Customer)
     end

     it "re-renders the 'new' template" do
       # Trigger the behavior that occurs when invalid params are submitted
       allow_any_instance_of(Customer).to receive(:save).and_return(false)
       post :create, params: {:customer => { name: "" }}
       expect(response).to render_template("new")
     end
   end
 end
 describe "DELETE destroy" do
   it "destroys the requested customer" do
     customer = Customer.create! valid_attributes
     expect {
       delete :destroy, params: {:id => customer.to_param}
     }.to change(Customer, :count).by(-1)
   end

   it "redirects to the customers list" do
     customer = Customer.create! valid_attributes
     delete :destroy, params: {:id => customer.to_param}
     expect(response).to redirect_to(customers_url)
   end

   it "fails if there are bills" do
     customer = Customer.create! valid_attributes
     bill = FactoryBot.create(:bill, customer_id: customer.id)
     expect {
       delete :destroy, params: {:id => customer.to_param}
     }.to change(Customer, :count).by(0)
   end
 end
end
