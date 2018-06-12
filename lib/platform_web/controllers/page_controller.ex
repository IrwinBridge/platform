defmodule PlatformWeb.PageController do
  use PlatformWeb, :controller

  alias Platform.Helper

  def index(conn, _params) do
    Helper.render_main_page_by_role(conn, "index.html")
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfuly")
    |> redirect(to: "/login")
  end
end
