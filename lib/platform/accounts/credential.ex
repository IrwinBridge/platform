defmodule Platform.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Platform.Accounts.{User, Credential}


  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "passwords does not match")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  @doc false
  def changeset_wo_pass_check(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc false
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
