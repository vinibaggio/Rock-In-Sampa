require 'spec_helper'

describe Contact do
  after(:each) do
    Mail::TestMailer.deliveries = []
  end

  describe "#valid?" do
    it "validates all attributes" do
      contact = Contact.new(contact_attributes)
      contact.must_be :valid?
    end

    it "invalidates empty title" do
      attributes = contact_attributes.merge('title' => '')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end

    it "invalidates empty name" do
      attributes = contact_attributes.merge('name' => '')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end

    it "invalidates empty email" do
      attributes = contact_attributes.merge('email' => '')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end

    it "invalidates empty message (honey pot is not filled)" do
      attributes = contact_attributes.merge('honey_pot' => '')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end

    it "invalidates filled honey pot (message is filled)" do
      attributes = contact_attributes.merge('message' => 'abc')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end

    it "invalidates invalid email" do
      attributes = contact_attributes.merge('email' => '%%')
      contact = Contact.new(attributes)
      contact.wont_be :valid?
    end
  end

  describe "#deliver" do
    it "returns falsy when message is invalid" do
      attributes = contact_attributes.merge('email' => '')
      contact = Contact.new(attributes)
      refute contact.deliver
    end

    it "returns truthy when message is valid" do
      contact = Contact.new(contact_attributes)
      assert contact.deliver
    end

    it "sends email with appropriate body content" do
      contact = Contact.new(contact_attributes)
      contact.deliver

      email = Mail::TestMailer.deliveries.first
      email.subject.must_equal '[Contato Rock In Sampa] Suggestion'
      email.body.to_s.must_equal <<-EOM
Contato de Arthur Dent <arthur@hitchhiker.com>

Hello dear earthling.
EOM
    end
  end

  describe "#delivery_attempted" do
    it "returns false when the object has not been delivered" do
      contact = Contact.new
      contact.wont_be :delivery_attempted
    end

    it "returns true when the object has been tried to be delivered with errors" do
      contact = Contact.new({})
      contact.deliver

      contact.must_be :delivery_attempted
    end

    it "returns false when the object has been delivered successfully" do
      contact = Contact.new(contact_attributes)
      contact.deliver

      contact.must_be :delivery_attempted?
    end
  end

  def contact_attributes
    {
      'title' => 'Suggestion',
      'name' => 'Arthur Dent',
      'email' => 'arthur@hitchhiker.com',
      'honey_pot' => 'Hello dear earthling.'
    }
  end
end
