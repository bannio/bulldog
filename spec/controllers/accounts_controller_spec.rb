require 'rails_helper'

describe AccountsController do

  login_user # so authenticate_user! works and sets @user


  describe "GET #show" do
    it "assigns the requested account as @account" do
      account = create(:account, user: @user)
      get :show, id: account
      expect(assigns(:account)).to eq account
    end

    it "renders the show template" do
      account = create(:account, user: @user)
      get :show, id: account
      expect(response).to render_template :show
    end
    it "only shows me accounts I own" do
      other_user = create(:user)
      account = create(:account)
      account2 = create(:account, user: other_user)
      request.env["HTTP_REFERER"]=root_path
      get :show, id: account2
      expect(response).to redirect_to root_path
    end
    it "doesn't expect hackers to have a valid HTTP_REFERER" do
      other_user = create(:user)
      account = create(:account)
      account2 = create(:account, user: other_user)
      #request.env["HTTP_REFERER"]=root_path
      get :show, id: account2
      expect(response).to redirect_to root_path
    end 
  end

  describe "GET #new_card" do
    it "assigns account as @account" do
      get :new_card, id: @account
      expect(assigns(:account)).to eq @account
    end
  end 

  describe "GET #new" do
    it "assigns an new account as @account" do
      plan = FactoryGirl.create(:plan)
      get :new, plan_id: plan.to_param
      expect(assigns(:account)).to be_a_new(Account)
    end
  end

  describe "GET #edit" do
    it "assigns the requested account as @account" do
      account = create(:account, user: @user)
      get :edit, id: account
      expect(assigns(:account)).to eq account
    end

    it "renders the edit template" do
      account = FactoryGirl.create(:account, user: @user)
      get :edit, id: account
      expect(response).to render_template :edit
    end
  end

  it "doesn't edit someone elses's account" do
      other_user = create(:user)
      account2 = create(:account, user: other_user)
      request.env["HTTP_REFERER"]=root_path
      get :edit, id: account2
      expect(response).to redirect_to root_path
    end

  describe "POST #create" do

    before do
      allow_any_instance_of(Account).to receive(:create_user).and_return(true)
    end

    context "with valid attributes" do
      before(:each) do

        allow_any_instance_of(Sale).to receive(:process!).and_return(true)
        allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
        stripe_customer = OpenStruct.new(id: "cust_id")
        allow(Stripe::Customer).to receive(:create).with(anything()).and_return(stripe_customer)
        allow_any_instance_of(Account).to receive(:get_next_invoice_date).and_return(nil)
      end
      subject {post :create, account: attributes_for(:account).merge(user_id: "", 
        stripe_customer_token: nil,
        stripe_card_token: "card",
        email: "newaccount@example.com"
        )}

      it "redirects to home path" do
        expect(subject).to redirect_to home_path
      end
      it "flashes a message" do
        expect(subject.request.flash[:notice]).to_not be_nil
      end
      it "creates a user" do
        expect_any_instance_of(Account).to receive(:create_user)
        subject
      end
    end

    it 'does not creates a new account if stripe fails to create a token' do
      allow_any_instance_of(Account).to receive(:create_stripe_customer).and_return(false)
      expect {
        post :create, account: attributes_for(:account).merge(user_id: "", 
          stripe_customer_token: nil,
          stripe_card_token: "xx"
          )
      }.to change(Account, :count).by(0)
    end
    context "does not create a sale" do
      it 'if account is invalid - no email' do
        expect_any_instance_of(Account).to_not receive(:process_subscription)
        post :create, account: attributes_for(:account).merge(user_id: "", 
          stripe_customer_token: nil,
          stripe_card_token: "card",
          email: ""
          )
      end
      it 'if account is invalid - no name' do
        expect_any_instance_of(Account).to_not receive(:process_subscription)
        post :create, account: attributes_for(:account).merge(user_id: "", 
          stripe_customer_token: nil,
          stripe_card_token: "card",
          name: ""
          )
      end
    end
  end

  describe "GET #cancel" do
    it "renders the cancel template" do
      account = create(:account, user: @user)
      get :cancel, id: account
      expect(response).to render_template :cancel
    end

    it "assigns the requested account as @account" do
      account = create(:account, user: @user)
      get :cancel, id: account
      expect(assigns(:account)).to eq account
    end
  end

  describe "PATCH #update" do
    before :each do
      @account = create(:account, name: 'Test Account')
      allow_any_instance_of(Sale).to receive(:process!).and_return(true)
      allow_any_instance_of(Sale).to receive(:cancel!).and_return(true)
      allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
      stripe_customer = OpenStruct.new(id: "cust_id")
      allow(Stripe::Customer).to receive(:retrieve).with(anything()).and_return(stripe_customer)
    end
    context "with valid attributes" do
      it "finds the account in question" do
        patch :update, id: @account, account: attributes_for(:account)
        expect(assigns(:account)).to eq(@account)
      end
      it "applies the requested changes" do
        patch :update, id: @account, account: attributes_for(:account,
          name: "New Account")
        @account.reload
        expect(@account.name).to eq "New Account"
      end
      it "redirects to the updated account" do
        patch :update, id: @account, account: attributes_for(:account)
        expect(response).to redirect_to @account
      end
      it "redirects to goodbye when account cancelled" do
        patch :update, id: @account, account: attributes_for(:account).merge(plan_id: 0)
        expect(response).to redirect_to page_path('goodbye')
      end
      it "logs out user when account cancelled" do
        patch :update, id: @account, account: attributes_for(:account).merge(plan_id: 0)
        expect(subject.current_user).to be_nil
      end
    end
    context "with invalid attributes" do
      it "does not apply the requested changes" do
        patch :update, id: @account, account: attributes_for(:account,
          name: "")
        @account.reload
        expect(@account.name).to eq "Test Account"
      end
      it "renders the edit template" do
        patch :update, id: @account, account: attributes_for(:account,
          name: "")
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update_card" do

    let(:attrs){{stripe_card_token: "card_token"}}

    it "redirects to the updated account on success" do
      allow_any_instance_of(Account).to receive(:update_card).and_return(true)
      patch :update_card, id: @account, account: attrs
      expect(response).to redirect_to @account
    end
    it "renders new_card on failure" do
      allow_any_instance_of(Account).to receive(:update_card).and_return(false)
      patch :update_card, id: @account, account: attrs
      expect(response).to render_template :new_card
    end
    it "flashes an error message on failure" do
      allow_any_instance_of(Account).to receive(:update_card).and_return(false)
      patch :update_card, id: @account, account: attrs
      expect(flash[:error]).to eq "There was a problem with your payment card"
    end

  end

end
