defmodule UserPortalWeb.AccessTokenChannel do
  use UserPortalWeb, :channel
  alias UserPortal.Account
  alias UserPortal.UserEmail
  alias UserPortal.Mailer
  def join("access:lobby", _payload, socket) do
    {:ok, socket}
  end
  def handle_in("create:user", %{"user" => user_params}, socket) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        UserEmail.welcome(user)|>Mailer.deliver
        resp = %{data: %{id: user.id,
          name: user.name,
          username: user.username,
          email: user.email,
          token: user.token,
          verified: user.email_verified }
        }
        push socket, "create:user", resp
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{errors: "Could not create user"}}, socket}
    end
  end

  def handle_in("create:login", %{"user" => %{"username" => username, "password" =>  password}}, socket)  do
    case UserPortalWeb.Auth.login_by_username_and_pass(username, password)  do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user, :access)
        resp = %{data: %{access_token: jwt}}
        push socket, "create", resp
        {:noreply, socket}
      {:err, :notverified} ->
        {:reply, {:error, %{errors: "please verify your email address"}}, socket}
      {:err, :unauthorized} ->
        {:reply, {:error, %{errors: "user password incorrect"}}, socket}
      {:err, :notfound} ->
        {:reply, {:error, %{errors: "user not found"}}, socket}
    end
  end
end