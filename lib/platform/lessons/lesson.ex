defmodule Platform.Lessons.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  alias Platform.Lessons.Lesson
  alias Platform.Lessons.Page


  schema "lessons" do
    field :grammar, :string
    field :img_uri, :string
    field :order, :integer
    field :tags, :string
    field :title, :string
    field :words, :string
    field :level, :string
    field :section, :string

    has_many :pages, Page

    timestamps()
  end

  @doc false
  def changeset(%Lesson{} = lesson, attrs) do
    lesson
    |> cast(attrs, [:title, :img_uri, :grammar, :words, :tags, :order, :level, :section])
    |> validate_required([:title])
  end
end
