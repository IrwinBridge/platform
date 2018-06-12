defmodule Platform.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :about, :string
      add :avatar_url, :string
      add :is_admin, :boolean, default: false, null: false
      add :is_moderator, :boolean, default: false, null: false
      add :name, :string
      add :surname, :string
      add :username, :string
      add :role, :string, default: "student", null: false
      add :lessons_balance, :integer, default: 0, null: false
      add :lessons, :map

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
