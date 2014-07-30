require 'rails_helper'

describe Contact do
  before do
    @attr = {
      name: "Mr Contact",
      email: "mc@example.com",
      message: "Here is my message",
      mail_list: '1'
    }
  end

  it "is valid with valid attributes" do
    expect(Contact.new(@attr)).to be_valid
  end

  it "validates presence of name" do
    expect(Contact.new(@attr.merge(name: ""))).to_not be_valid
  end

  it "validates name less than 30 characters" do
    name = 'a' * 31
    expect(Contact.new(@attr.merge(name: name))).to_not be_valid
  end

  it "validates presence of email" do
    expect(Contact.new(@attr.merge(email: ""))).to_not be_valid
  end

  it "validates email format" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |addr|
      expect(Contact.new(@attr.merge(email: addr))).to_not be_valid
    end
  end

  context "mail_only?" do
    it "is true when message is blank and mail_list checked" do
      c = Contact.new(@attr.merge(message: ""))
      expect(c.mail_only?).to be_truthy
    end

    it "is false when message is not blank and mail_list checked" do
      c = Contact.new(@attr)
      expect(c.mail_only?).to be_falsey
    end

    it "is false when message is not blank and mail_list not checked" do
      c = Contact.new(@attr.merge(mail_list: "0"))
      expect(c.mail_only?).to be_falsey
    end
  end

  context "message_only?" do
    it "is true when message is not blank and mail_list is not checked" do
      c = Contact.new(@attr.merge(mail_list: '0'))
      expect(c.message_only?).to be_truthy
    end

    it "is false when message is not blank and mail_list is checked" do
      c = Contact.new(@attr)
      expect(c.message_only?).to be_falsey
    end

    it "is false when message is blank and mail_list is not checked" do
      c = Contact.new(@attr.merge(message: "", mail_list: "0"))
      expect(c.message_only?).to be_falsey
    end
  end

  it "validates message length less than 500" do
    msg = 'a' * 501
    expect(Contact.new(@attr.merge(message: msg))).to_not be_valid
    expect(Contact.new(@attr.merge(message: "Short message"))).to be_valid
  end

  it "will not try to send email if no address given" do
    c = Contact.new(@attr.merge(email: ""))
    expect(c.add_to_mail_list).to eq nil
  end

  it "will not try to send email if mail_list not checked" do
    c = Contact.new(@attr.merge(mail_list: "0"))
    expect(c.add_to_mail_list).to eq nil
  end

  it "adds to mail list if mail_list checked" do
    c = Contact.new(@attr)
    c.stub_chain(:mailchimp, :lists, :subscribe).and_return(true)
    expect(c.add_to_mail_list).to be_truthy
  end

end