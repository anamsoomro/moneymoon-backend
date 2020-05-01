
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: "anam", email: "anamsoomroed@gmail.com").welcome_email
    # that with is sending the params
  end
end