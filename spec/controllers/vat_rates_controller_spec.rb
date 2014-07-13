require 'spec_helper'

describe VatRatesController do

  login_user

  def create_account
    user = subject.current_user
    account = FactoryGirl.create(:account, user_id: user.id, plan_id: 2)
    # Account.current_id = account.id
  end

  def valid_attributes
   { name: "Standard",
    rate: "20", 
    account_id: create_account.id,
    active: true
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

   it "assigns all vat rates as @vat_rates" do
     vat_rate = VatRate.create! valid_attributes
     get :index, {}
     assigns(:vat_rates).should eq([vat_rate])
   end

   it "shows active rates by default" do
     vat_rate = VatRate.create! valid_attributes.merge(active: false)
     get :index, {}
     assigns(:vat_rates).should eq([])
   end

   it "shows inactive rates by request" do
     vat_rate = VatRate.create! valid_attributes.merge(active: false)
     get :index, {all: true}
     assigns(:vat_rates).should eq([vat_rate])
   end
 end

 describe "GET new" do
   it "builds a rate with an account id" do
     create_account
     get :new, {format: :js}
     assigns(:vat_rate).should be_a_new(VatRate)
     expect(assigns(:vat_rate).account_id).to_not be_blank
   end
   it "builds a rate with active set to true" do
     create_account
     get :new, {format: :js}
     assigns(:vat_rate).should be_a_new(VatRate)
     expect(assigns(:vat_rate).active?).to be_true
   end
 end 

 describe "GET edit" do
   it "assigns the requested rate as @vat_rate" do
     vat_rate = VatRate.create! valid_attributes
     get :edit, {id: vat_rate.to_param, format: :js}
     expect(assigns(:vat_rate)).to eq vat_rate
   end
 end

 describe "PATCH #update" do
   before :each do
     @vat_rate = VatRate.create! valid_attributes
   end

   context "with valid attributes" do
     it "updates the expected vat rate" do
       patch :update, id:  @vat_rate, vat_rate: {name: "new name"}, format: :js
       expect(assigns(:vat_rate)).to eq @vat_rate 
     end
   end
   context "with invalid attributes" do
     it "renders edit" do
       patch :update, id:  @vat_rate, vat_rate: {name: ""}, format: :js
       expect(response).to render_template :edit
     end

     it "rejects someone else's rate" do
       vat_rate = VatRate.create! valid_attributes.merge(account_id: "999")
       patch :update, id:  vat_rate, vat_rate: valid_attributes.merge(account_id: "999"), format: :js
       expect(response).to redirect_to home_path
     end
   end
 end

 describe "POST create" do
   context "with valid params" do
     it "creates a new vat rate" do
       expect {
        post :create, {vat_rate: valid_attributes}
       }.to change(VatRate, :count).by(1)
     end

     it "assigns a newly created rate as @vat_rate" do
       post :create, {vat_rate: valid_attributes}
       expect(assigns(:vat_rate)).to be_a(VatRate)
       expect(assigns(:vat_rate)).to be_persisted
     end

     it "redirects to the index" do
       post :create, {vat_rate: valid_attributes}
       expect(response).to redirect_to vat_rates_path
     end
   end

   context "with invalid params" do
     it "assigns a new but unsaved vat rate" do
       #VatRate.any_instance.stub(:save).and_return(false)
       post :create, {vat_rate: valid_attributes.merge(name: ""), format: :js}
       expect(assigns(:vat_rate)).to be_a_new(VatRate)
     end

     it "renders the new template" do
       post :create, {vat_rate: valid_attributes.merge(name: ""), format: :js}
       expect(response).to render_template :new
     end
   end
 end

describe "DELETE destroy" do
  before :each do
     @vat_rate = VatRate.create! valid_attributes
  end

  it "destroys the vat rate (if no bills)" do
    expect {
      delete :destroy, {id: @vat_rate.to_param}
    }.to change(VatRate, :count).by(-1)
  end

  it "does not destroy if bills exist" do
    bill = FactoryGirl.create(:bill, account_id: @vat_rate.account_id, vat_rate_id: @vat_rate.id)
    expect {
      delete :destroy, {id: @vat_rate.to_param}
    }.to_not change(VatRate, :count).by(-1)
  end

  it "redirects to the vat rates index" do
    delete :destroy, {id: @vat_rate.to_param}
    expect(response).to redirect_to vat_rates_path
  end
 end

end
