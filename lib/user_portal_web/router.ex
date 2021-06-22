defmodule UserPortalWeb.Router do
  use UserPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end
  scope "/api", UserPortalWeb do
    pipe_through :api
#    get "/", PageController, :index
  end
  scope "/v1/api/auth", UserPortalWeb do
    pipe_through :api
    get "/verify_email/:token", AccessTokenController, :verify_email
  end
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: UserPortalWeb.Telemetry
    end
  end
end
