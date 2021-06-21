defmodule UserPortal.Repo do
  use Ecto.Repo,
    otp_app: :user_portal,
    adapter: Ecto.Adapters.Postgres
end
