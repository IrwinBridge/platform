defmodule Platform.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Platform.Accounts.{User, Credential}


  schema "users" do
    field :about, :string
    field :avatar_url, :string
    field :is_admin, :boolean, default: false
    field :is_moderator, :boolean, default: false
    field :lessons, :map
    field :lessons_balance, :integer, default: 0
    field :name, :string
    field :role, :string
    field :surname, :string
    field :username, :string

    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:about, :avatar_url, :is_admin, :is_moderator, :name, :surname, :username, :role, :lessons_balance, :lessons])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
