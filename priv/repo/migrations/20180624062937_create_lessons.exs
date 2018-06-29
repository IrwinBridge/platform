defmodule Platform.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :title, :string
      add :img_uri, :string, default: ""
      add :grammar, :string, default: ""
      add :words, :string, default: ""
      add :tags, :string, default: ""
      add :section, :string, default: "General"
      add :level, :string, default: "Elementary"
      add :order, :integer

      timestamps()
    end

  end
end
