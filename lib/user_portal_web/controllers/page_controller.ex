defmodule UserPortalWeb.PageController do
  use UserPortalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
