require 'spec_helper'

describe CustomersController do

  login_user
  # let(:account){mock_model Account, current_id: 1}
  
  def create_account
    user = subject.current_user
    account = FactoryGirl.create(:account, user_id: user.id)
    # Account.current_id = account.id
  end

  def valid_attributes
   { name: "A Customer",
   address: "", 
   postcode: "",
   account_id: create_account.id
   }
 end

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "GET 'index'" do
    it "returns http success even when no customers" do
      create_account
      get 'index'
      response.should be_success
    end
  end
 
 describe "GET index" do
   it "assigns all customers as @customers" do
     customer = Customer.create! valid_attributes
     get :index, {}
     assigns(:customers).should eq([customer])
   end
 end
 
 describe "GET new" do
   it "assigns a new customer as @customer" do
     create_account
     get :new, {}
     assigns(:customer).should be_a_new(Customer)
   end
 end

 describe "GET edit" do
   it "assigns the requested customer as @customer" do
     customer = Customer.create! valid_attributes
     get :edit, {:id => customer.to_param}
     assigns(:customer).should eq(customer)
   end
 end

 describe "POST create" do
   describe "with valid params" do
     it "creates a new Customer" do
       expect {
         post :create, {:customer => valid_attributes}
       }.to change(Customer, :count).by(1)
     end

     it "assigns a newly created customer as @customer" do
       post :create, {:customer => valid_attributes}
       assigns(:customer).should be_a(Customer)
       assigns(:customer).should be_persisted
     end

     it "redirects to the customers index" do
       post :create, {:customer => valid_attributes}
       response.should redirect_to(customers_url)
     end
   end

   describe "with invalid params" do
     it "assigns a newly created but unsaved customer as @customer" do
       Customer.any_instance.stub(:save).and_return(false)
       post :create, {:customer => { name: "" }}
       assigns(:customer).should be_a_new(Customer)
     end

     it "re-renders the 'new' template" do
       # Trigger the behavior that occurs when invalid params are submitted
       Customer.any_instance.stub(:save).and_return(false)
       post :create, {:customer => { name: "" }}
       response.should render_template("new")
     end
   end
 end
 describe "DELETE destroy" do
   it "destroys the requested customer" do
     customer = Customer.create! valid_attributes
     expect {
       delete :destroy, {:id => customer.to_param}
     }.to change(Customer, :count).by(-1)
   end

   it "redirects to the customers list" do
     customer = Customer.create! valid_attributes
     delete :destroy, {:id => customer.to_param}
     response.should redirect_to(customers_url)
   end
   
   it "fails if there are bills" do
     customer = Customer.create! valid_attributes
     bill = FactoryGirl.create(:bill, customer_id: customer.id)
     expect {
       delete :destroy, {:id => customer.to_param}
     }.to change(Customer, :count).by(0)    
   end
 end
end
