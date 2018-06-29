defmodule Platform.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :order, :integer
      add :title, :string
      add :type, :string, default: "Lesson"

      add :titles, :string
      add :ex_count, :integer
      add :content, :text
      add :answers, :text

      add :lesson_id, references(:lessons, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
