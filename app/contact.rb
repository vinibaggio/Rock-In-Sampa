class Contact
  attr_reader :title, :name, :email, :message, :delivery_attempted
  alias delivery_attempted? delivery_attempted

  def initialize(attributes={})
    @title              = attributes['title']
    @name               = attributes['name']
    @email              = attributes['email']
    @message            = attributes['honey_pot']
    @honey_pot          = attributes['message']
    @delivery_attempted = false
  end

  def valid?
    !blank?(@title) &&
      !blank?(@name) &&
      !blank?(@email) &&
      !blank?(@message) &&
      blank?(@honey_pot) &&
      valid_email?(@email)
  end

  def deliver
    @delivery_attempted = true

    return if not valid?

    title = @title
    message = build_message

    Mail.deliver do
      to App.settings['email_to']
      from 'admin@rockinsampa.com'
      subject "[Contato Rock In Sampa] #{title}"
      body message
    end
  end

  private

  def blank?(attribute)
    attribute.nil? || attribute.blank?
  end

  def valid_email?(email)
    email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  end

  def build_message
    msg = "Contato de #{@name} <#{@email}>\n\n"
    msg << @message
    msg << "\n"

    msg
  end
end
