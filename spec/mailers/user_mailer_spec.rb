require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :michael }

  specify "account_activation" do
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    expect(mail).to have_attributes subject: "Account activation", to: [user.email], from: ["noreply@example.com"]
    expect(mail.body.encoded).to match user.name
    expect(mail.body.encoded).to match user.activation_token
    expect(mail.body.encoded).to match CGI::escape(user.email)
  end

  specify "password_reset" do
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    expect(mail).to have_attributes subject: "Password reset", to: [user.email], from: ["noreply@example.com"]
    expect(mail.body.encoded).to match user.reset_token
    expect(mail.body.encoded).to match CGI::escape(user.email)
  end
end
