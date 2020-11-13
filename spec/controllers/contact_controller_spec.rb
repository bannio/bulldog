require 'rails_helper'

def valid_attrs
    {
      name: "my contact",
      email: "test@example.com",
      mail_list: '1',
      message: "Here is my message"
    }
end

describe ContactsController do
  describe "GET#new" do
    it "assigns a new contact" do
      get :new, {}
      expect(assigns(:contact)).to_not be_nil
    end
  end

  # describe "POST#create" do
  #   before do
  #     allow_any_instance_of(Contact).to receive(:add_to_mail_list).and_return(true)
  #   end

  #   context "with full valid attributes" do
  #     it "assigns a new contact" do
  #       post :create, params: {contact: valid_attrs}
  #       expect(assigns(:contact)).to be_an_instance_of(Contact)
  #     end
  #     it "sends an email" do
  #       expect{ post :create, params: {contact: valid_attrs} }.
  #        to change { ActionMailer::Base.deliveries.count }.by(1)
  #     end
  #     it "redirects to home path" do
  #       post :create, params: {contact: valid_attrs}
  #       expect(response).to redirect_to home_path
  #     end
  #   end

  #   context "with invalid attributes" do
  #     it "renders new template" do
  #       post :create, params: {contact: {name: ""}}
  #       expect(response).to render_template 'new'
  #     end
  #   end

  #   context "with mail_only? true" do
  #     it "adds to mail list" do
  #       expect_any_instance_of(Contact).to receive(:add_to_mail_list)
  #       post :create, params: {contact: valid_attrs.merge(message: "")}
  #     end
  #     it "does not send an email" do
  #       expect{ post :create, params: {contact: valid_attrs.merge(message: "")} }.
  #        to change { ActionMailer::Base.deliveries.count }.by(0)
  #     end
  #     it "redirects to home path" do
  #       post :create, params: {contact: valid_attrs.merge(message: "")}
  #       expect(response).to redirect_to home_path
  #     end
  #   end

  #   context "with message_only? true" do
  #     it "does not add to mail list" do
  #       expect_any_instance_of(Contact).to_not receive(:add_to_mail_list)
  #       post :create, params: {contact: valid_attrs.merge(mail_list: "0")}
  #     end
  #     it "does send an email" do
  #       expect{ post :create, params: {contact: valid_attrs.merge(mail_list: "0")} }.
  #        to change { ActionMailer::Base.deliveries.count }.by(1)
  #     end
  #     it "redirects to home path" do
  #       post :create, params: {contact: valid_attrs.merge(mail_list: "0")}
  #       expect(response).to redirect_to home_path
  #     end
  #   end
  # end

end