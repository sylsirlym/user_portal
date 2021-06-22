defmodule UserPortal.UserEmail do
  import Swoosh.Email
  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Sirlym Portal", "musyokisyl81@gmail.com"})
    |> subject("Welcome Home!!")
    |> html_body("<p>Thanks for signing up with us</p>
            <p>Please click the link below to verify your email address</p>
            <a href=https://sxxxx.com/v1/api/auth/verify_email/#                    {user.token}>Verify address</a>"
       )
  end
end