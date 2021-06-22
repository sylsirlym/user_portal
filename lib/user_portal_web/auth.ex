defmodule UserPortal.Web.Auth do
  import Hasher
  alias UserPortal.Account
  def login_by_username_and_pass(username, given_pass) do
    user = Account.get_by(username)
    if user do
      cond do
        user.email_verified && check_password_hash(given_pass, user.password_hash) ->
          {:ok, user}
        user.email_verified && check_password_hash(given_pass, user.password_hash) == false ->
          {:err, :unauthorized}
        not user.email_verified ->
          {:err, :notverified}
      end
    else
      {:err, :notfound}
    end

  end

end