defmodule UserPortal.Mailer do
  use Swoosh.Mailer, otp_app: :user_portal
end
defmodule UserPortal.UserEmail do
  import Swoosh.Email
end
