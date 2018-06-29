defmodule Platform.Lessons.Page do
  use Ecto.Schema
  import Ecto.Changeset

  alias Platform.Lessons.Lesson
  alias Platform.Lessons.Page


  schema "pages" do
    field :order, :integer
    field :title, :string
    field :type, :string

    field :titles, :string
    field :ex_count, :integer
    field :content, :string
    field :answers, :string

    belongs_to :lesson, Lesson

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:order, :title, :type, :titles, :content, :ex_count, :answers])
    |> validate_required([:title, :type])
  end
end
