defmodule Platform.Lessons do
  @moduledoc """
  The Lessons context.
  """

  import Ecto.Query, warn: false
  alias Platform.Repo

  alias Platform.Lessons.Lesson
  alias Platform.Lessons.Page

  @doc """
  Returns the list of lessons.

  ## Examples

      iex> list_lessons()
      [%Lesson{}, ...]

  """
  def list_lessons do
    Repo.all(Lesson)
  end

  @doc """
  Gets a single lesson.

  Raises `Ecto.NoResultsError` if the Lesson does not exist.

  ## Examples

      iex> get_lesson!(123)
      %Lesson{}

      iex> get_lesson!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lesson!(id) do
    Repo.get!(Lesson, id)
    |> Repo.preload(:pages)
  end

  @doc """
  Creates a lesson.

  ## Examples

      iex> create_lesson(%{field: value})
      {:ok, %Lesson{}}

      iex> create_lesson(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:pages, with: &Page.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.

  ## Examples

      iex> update_lesson(lesson, %{field: new_value})
      {:ok, %Lesson{}}

      iex> update_lesson(lesson, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:pages, with: &Page.changeset/2)
    |> Repo.update()
  end

  @doc """
  Deletes a Lesson.

  ## Examples

      iex> delete_lesson(lesson)
      {:ok, %Lesson{}}

      iex> delete_lesson(lesson)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson changes.

  ## Examples

      iex> change_lesson(lesson)
      %Ecto.Changeset{source: %Lesson{}}

  """
  def change_lesson(%Lesson{} = lesson) do
    Lesson.changeset(lesson, %{})
  end


  # PAGES
  def get_page!(id) do
    Repo.get!(Page, id)
    |> Repo.preload(:lesson)
  end

  def create_page(id, attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Ecto.Changeset.put_change(:lesson_id, id)
    |> Repo.insert()
  end

  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end



  def update_lessons_order(%Lesson{} = lesson) do
    # getting all lessons from current section and level
    query = from l in Lesson,
      where: l.section == ^lesson.section and l.level == ^lesson.level,
      order_by: l.order

    # update all orders of all lessons
    Repo.all(query)
    |> Enum.with_index(1)
    |> Enum.each(fn {l, idx} -> update_lesson(l, %{order: idx}) end)
  end


  def update_pages_order_on_create(%Page{} = page, order) do
    case order do
      nil ->
        # getting all pages for current type
        query = from p in Page,
          where: p.lesson_id == ^page.lesson_id and p.type == ^page.type,
          order_by: p.order

        # update all orders of all pages
        Repo.all(query)
        |> Enum.with_index(1)
        |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)

      _ ->
        # getting all pages for current type and more than wanted order
        query = from p in Page,
          where: p.lesson_id == ^page.lesson_id and p.type == ^page.type
            and p.order >= ^order,
          order_by: p.order

        # update all orders of all pages
        Repo.all(query)
        |> Enum.with_index(order)
        |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)

        # set order of our page
        update_page(page, %{order: order})

        # update if more than last order
        tmp = from p in Page,
          where: p.lesson_id == ^page.lesson_id and p.type == ^page.type,
          order_by: p.order

        Repo.all(tmp)
        |> Enum.with_index(1)
        |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)
    end

  end

  def update_pages_order_on_update(%Page{} = page, order) do
    # getting all pages for current type and more than wanted order
    query = from p in Page,
      where: p.lesson_id == ^page.lesson_id and p.type == ^page.type
        and p.order >= ^order,
      order_by: p.order

    # update all orders of all pages
    Repo.all(query)
    |> Enum.with_index(order)
    |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)

    # set order of our page
    update_page(page, %{order: order})

    # update if more than last order
    tmp = from p in Page,
      where: p.lesson_id == ^page.lesson_id and p.type == ^page.type,
      order_by: p.order

    Repo.all(tmp)
    |> Enum.with_index(1)
    |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)
  end

  def update_pages_order_on_delete(type, lesson_id) do
    # getting all pages for current type
    query = from p in Page,
      where: p.lesson_id == ^lesson_id and p.type == ^type,
      order_by: p.order

    # update all orders of all pages
    Repo.all(query)
    |> Enum.with_index(1)
    |> Enum.each(fn {p, idx} -> update_page(p, %{order: idx}) end)
  end
end
