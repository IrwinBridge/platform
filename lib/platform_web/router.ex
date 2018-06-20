defmodule PlatformWeb.Router do
  use PlatformWeb, :router

  # PUBLIC
  pipeline :public do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :login_smart_redirect
  end

  # LOGGED IN
  pipeline :secured do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :authenticate_user
  end

  # MODERATOR
  pipeline :moderator do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :authenticate_user
    plug :check_if_moderator
  end

  # ADMIN
  pipeline :admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :authenticate_user
    plug :check_if_admin
  end

  # ADMIN ONLY
  scope "/", PlatformWeb do
    pipe_through :admin

    resources "/users", UserController

    #CMS functionality lessons
  end

  # MODERATOR ONLY
  scope "/", PlatformWeb do
    pipe_through :moderator

    #CMS functionality lessons
  end

  # LOGGED IN
  scope "/", PlatformWeb do
    pipe_through :secured

    #main_page
    resources "/", PageController, only: [:index, :delete]

    #lessons
  end

  # PUBLIC
  scope "/", PlatformWeb do
    pipe_through :public

    # TODO: DELETE!!!!!!!!
    resources "/users", UserController

    resources "/register", RegistrationController, only: [:index, :create]
    resources "/login", LoginController, only: [:index, :create]
  end


  # Auth plug
  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/login")
        |> halt()
      user_id ->
        # YOU can USE it for ROLE checking
        assign(conn, :current_user, Platform.Accounts.get_user!(user_id))
    end
  end

  # MODERATOR check plug
  defp check_if_moderator(conn, _) do
    if(not conn.assigns.current_user.is_moderator) do
      # Just redirect to 404 page
      conn
      |> Phoenix.Controller.put_flash(:error, "Access denied")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end

    conn
  end

  # ADMIN check plug
  defp check_if_admin(conn, _) do
    if(not conn.assigns.current_user.is_admin) do
      # Just redirect to 404 page
      conn
      |> Phoenix.Controller.put_flash(:error, "Access denied")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end

    conn
  end

  # Check if in login but already logged in
  defp login_smart_redirect(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
      user_id ->
         if(String.contains?(Phoenix.Controller.current_path(conn), "login")) do
            Phoenix.Controller.redirect(conn, to: "/")
            |> halt()
         end
    end

    conn
  end

end
