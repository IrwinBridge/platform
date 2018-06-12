defmodule PlatformWeb.RegistrationController do
  use PlatformWeb, :controller

  alias Platform.Accounts
  alias Platform.Accounts.User

  def index(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You signed up successfully!")
        |> configure_session(drop: true)

        # Sign IN
        case Accounts.authenticate_by_email_password(user.credential.email, user.credential.password) do
          {:ok, user} ->
            conn
            |> put_session(:user_id, user.id)
            |> configure_session(renew: true)
            |> redirect(to: "/")
          {:error, :unauthorized} ->
            conn
            |> put_flash(:error, "Bad email/password combination")
            |> redirect(to: login_path(conn, :new))
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
