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

    let(:account){ instance_double('Account') }

    context "with valid attributes" do

      subject {post :create, account: attributes_for(:account).merge(user_id: "",
        stripe_customer_token: nil,
        email: "newaccount@example.com",
        mail_list: "1"
        )}

      it "redirects to page new_account" do
        allow(CreateAccount).to receive(:call).and_return(account)
        allow(account).to receive(:persisted?).and_return(true)
        expect(subject).to redirect_to page_path('new_account')
      end
    end

    context "with invalid attributes" do

      subject {post :create, account: {name: ""}}

      it "renders flash message" do
        allow(CreateAccount).to receive(:call).and_return(account)
        allow(account).to receive(:persisted?).and_return(false)
        allow(account).to receive_message_chain(:errors, :full_messages).and_return("account has errors")
        subject
        expect(flash[:error]).to include("account has errors")
      end

      it "renders new" do
        allow(CreateAccount).to receive(:call).and_return(account)
        allow(account).to receive(:persisted?).and_return(false)
        allow(account).to receive_message_chain(:errors, :full_messages)
        expect(subject).to render_template :new
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
    before { @account = create(:account, name: 'Test Account') }

    context "with valid attributes" do
      before {allow(UpdateAccount).to receive_message_chain(:new, :update).and_return(true)}
      it "finds the account in question" do
        patch :update, id: @account, account: attributes_for(:account)
        expect(assigns(:account)).to eq(@account)
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
      before {allow(UpdateAccount).to receive_message_chain(:new, :update).and_return(false)}

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
      # allow_any_instance_of(Account).to receive(:update_card).and_return(true)

      allow(subject).to receive(:update_card_service).and_return(true)
      patch :update_card, id: @account, account: attrs
      expect(response).to redirect_to @account
    end
    it "renders new_card on failure" do
      # allow_any_instance_of(Account).to receive(:update_card).and_return(false)
      allow(subject).to receive(:update_card_service).and_return(false)
      patch :update_card, id: @account, account: attrs
      expect(response).to render_template :new_card
    end
    it "flashes an error message on failure" do
      # allow_any_instance_of(Account).to receive(:update_card).and_return(false)
      allow(subject).to receive(:update_card_service).and_return(false)
      patch :update_card, id: @account, account: attrs
      expect(flash[:error]).to eq "There was a problem with your payment card"
    end

  end

end
