defmodule PlatformWeb.LogoutController do
  use PlatformWeb, :controller

  def index(conn, _) do
    render(conn, "index.html") 
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfuly")
    |> redirect(to: "/login")
  end
end
