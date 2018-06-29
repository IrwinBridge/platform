defmodule PlatformWeb.PageController do
  use PlatformWeb, :controller

  alias Platform.Helper

  def index(conn, _params) do
    Helper.render_main_page(conn, "index.html")
  end
end
