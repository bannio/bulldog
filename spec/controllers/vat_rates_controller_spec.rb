require 'rails_helper'

describe VatRatesController do

  login_business_user

  def valid_attributes
   { name: "Standard",
    rate: "20",
    account_id: @account.id,
    active: true
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

   it "assigns all vat rates as @vat_rates" do
     vat_rate = VatRate.create! valid_attributes
     get :index, {}
     expect(assigns(:vat_rates)).to eq([vat_rate])
   end

   it "shows active rates by default" do
     vat_rate = VatRate.create! valid_attributes.merge(active: false)
     get :index, {}
     expect(assigns(:vat_rates)).to eq([])
   end

   it "shows inactive rates by request" do
     vat_rate = VatRate.create! valid_attributes.merge(active: false)
     get :index, params: {all: true}
     expect(assigns(:vat_rates)).to eq([vat_rate])
   end
 end

 describe "GET new" do
   it "builds a rate with an account id" do
     get :new, params: {format: :js}, xhr: true
     expect(assigns(:vat_rate)).to be_a_new(VatRate)
     expect(assigns(:vat_rate).account_id).to_not be_blank
   end
   it "builds a rate with active set to true" do
     get :new, params: {format: :js}, xhr: true
     expect(assigns(:vat_rate)).to be_a_new(VatRate)
     expect(assigns(:vat_rate).active?).to be_truthy
   end
 end

 describe "GET edit" do
   it "assigns the requested rate as @vat_rate" do
     vat_rate = VatRate.create! valid_attributes
     get :edit, params: {id: vat_rate.to_param, format: :js}, xhr: true
     expect(assigns(:vat_rate)).to eq vat_rate
   end
 end

 describe "PATCH #update" do
   before :each do
     @vat_rate = VatRate.create! valid_attributes
   end

   context "with valid attributes" do
     it "updates the expected vat rate" do
       patch :update, params: {id:  @vat_rate, vat_rate: {name: "new name"}, format: :js}
       expect(assigns(:vat_rate)).to eq @vat_rate
     end
   end
   context "with invalid attributes" do
     it "renders edit" do
       patch :update, params: {id:  @vat_rate, vat_rate: {name: ""}, format: :js}
       expect(response).to render_template :edit
     end

     it "rejects someone else's rate" do
       vat_rate = VatRate.create! valid_attributes.merge(account_id: "999")
       patch :update, params: {id:  vat_rate, vat_rate: valid_attributes.merge(account_id: "999"), format: :js}
       expect(response).to redirect_to home_path
     end
   end
 end

 describe "POST create" do
   context "with valid params" do
     it "creates a new vat rate" do
       expect {
        post :create, params: {vat_rate: valid_attributes}
       }.to change(VatRate, :count).by(1)
     end

     it "assigns a newly created rate as @vat_rate" do
       post :create, params: {vat_rate: valid_attributes}
       expect(assigns(:vat_rate)).to be_a(VatRate)
       expect(assigns(:vat_rate)).to be_persisted
     end

     it "redirects to the index" do
       post :create, params: {vat_rate: valid_attributes}
       expect(response).to redirect_to vat_rates_path
     end
   end

   context "with invalid params" do
     it "assigns a new but unsaved vat rate" do
       #VatRate.any_instance.stub(:save).and_return(false)
       post :create, params: {vat_rate: valid_attributes.merge(name: ""), format: :js}
       expect(assigns(:vat_rate)).to be_a_new(VatRate)
     end

     it "renders the new template" do
       post :create, params: {vat_rate: valid_attributes.merge(name: ""), format: :js}
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
      delete :destroy, params: {id: @vat_rate.to_param}
    }.to change(VatRate, :count).by(-1)
  end

  it "does not destroy if bills exist" do
    bill = FactoryBot.create(:bill, account_id: @vat_rate.account_id, vat_rate_id: @vat_rate.id)
    expect {
      delete :destroy, params: {id: @vat_rate.to_param}
    }.to change(VatRate, :count).by(0)
  end

  it "redirects to the vat rates index" do
    delete :destroy, params: {id: @vat_rate.to_param}
    expect(response).to redirect_to vat_rates_path
  end
 end

end
