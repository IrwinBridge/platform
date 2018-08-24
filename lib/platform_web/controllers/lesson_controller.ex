defmodule PlatformWeb.LessonController do
  use PlatformWeb, :controller

  alias Platform.Lessons
  alias Platform.Lessons.{Lesson, Page}

  alias Platform.{Helper}


  def index(conn, _params) do
    lessons = Lessons.list_lessons()

    elementary =
      Enum.filter(lessons, fn(lesson) -> lesson.level == "Elementary" end)
      |> Enum.sort_by(fn(lesson) -> lesson.order end)

    pre_int =
      Enum.filter(lessons, fn(lesson) -> lesson.level == "Pre-Intermediate" end)
      |> Enum.sort_by(fn(lesson) -> lesson.order end)

    int =
      Enum.filter(lessons, fn(lesson) -> lesson.level == "Intermediate" end)
      |> Enum.sort_by(fn(lesson) -> lesson.order end)

    upper_int =
      Enum.filter(lessons, fn(lesson) -> lesson.level == "Upper-Intermediate" end)
      |> Enum.sort_by(fn(lesson) -> lesson.order end)

    advanced =
      Enum.filter(lessons, fn(lesson) -> lesson.level == "Advanced" end)
      |> Enum.sort_by(fn(lesson) -> lesson.order end)

    Helper.render_lessons(conn, "index.html", %{lessons: lessons,
      elementary: elementary, pre_int: pre_int, int: int, upper_int: upper_int, advanced: advanced})
  end

  def new(conn, _params) do
    changeset = Lessons.change_lesson(%Lesson{})
    Helper.render_lessons(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lesson" => lesson_params}) do
    case Lessons.create_lesson(lesson_params) do
      {:ok, lesson} ->
        Lessons.update_lessons_order(lesson)

        conn
        |> put_flash(:info, "Lesson created successfully.")
        |> redirect(to: lesson_path(conn, :show, lesson))
      {:error, %Ecto.Changeset{} = changeset} ->
        Helper.render_lessons(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)

    prep_type =
      Enum.filter(lesson.pages, fn(page) -> page.type == "Preparation" end)
      |> Enum.sort_by(fn(page) -> page.order end)

    lesson_type =
      Enum.filter(lesson.pages, fn(page) -> page.type == "Lesson" end)
      |> Enum.sort_by(fn(page) -> page.order end)

    hw_type =
      Enum.filter(lesson.pages, fn(page) -> page.type == "Homework" end)
      |> Enum.sort_by(fn(page) -> page.order end)

    first_page = Lessons.get_first_page(lesson.id)

    case first_page do
      nil ->
        Helper.render_lessons(conn, "show.html",
          %{lesson: lesson, prep_type: prep_type, lesson_type: lesson_type, hw_type: hw_type,
            start_page_with_id: nil})
      _ ->
      Helper.render_lessons(conn, "show.html",
        %{lesson: lesson, prep_type: prep_type, lesson_type: lesson_type, hw_type: hw_type,
          start_page_with_id: first_page.id})
    end


  end

  def edit(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    changeset = Lessons.change_lesson(lesson)
    Helper.render_lessons(conn, "edit.html", %{lesson: lesson, changeset: changeset})
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Lessons.get_lesson!(id)

    case Lessons.update_lesson(lesson, lesson_params) do
      {:ok, lesson} ->
        Lessons.update_lessons_order(lesson) ## DO I REALLY NEED IT?

        conn
        |> put_flash(:info, "Lesson updated successfully.")
        |> redirect(to: lesson_path(conn, :show, lesson))
      {:error, %Ecto.Changeset{} = changeset} ->
        Helper.render_lessons(conn, "edit.html", %{lesson: lesson, changeset: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    {:ok, _lesson} = Lessons.delete_lesson(lesson)

    Lessons.update_lessons_order(lesson)

    conn
    |> put_flash(:info, "Lesson deleted successfully.")
    |> redirect(to: lesson_path(conn, :index))
  end


  # PAGES
  def new_page(conn, %{"lesson_id" => lesson_id}) do
    changeset = Lessons.change_page(%Page{})
    lesson = Lessons.get_lesson!(lesson_id)
    Helper.render_lessons(conn, "new_page.html", %{changeset: changeset, lesson: lesson})
  end

  def create_page(conn, %{"lesson_id" => lesson_id, "page" => page_params}) do
    id = String.to_integer(lesson_id)
    lesson = Lessons.get_lesson!(id)

    case Lessons.create_page(id, page_params) do
      {:ok, page} ->
        Lessons.update_pages_order_on_create(page, page.order)

        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: lesson_path(conn, :show, lesson))
      {:error, %Ecto.Changeset{} = changeset} ->
        Helper.render_lessons(conn, "new_page.html", %{changeset: changeset, lesson: lesson})
    end
  end

  def edit_page(conn, %{"page_id" => page_id}) do
    page = Lessons.get_page!(page_id)
    changeset = Lessons.change_page(page)
    Helper.render_lessons(conn, "edit_page.html", %{lesson: page.lesson, page: page, changeset: changeset})
  end

  def update_page(conn, %{"page_id" => page_id, "page" => page_params}) do
    page = Lessons.get_page!(page_id)
    lesson = page.lesson

    case Lessons.update_page(page, page_params) do
      {:ok, page} ->
        Lessons.update_pages_order_on_update(page, page.order)

        conn
        |> put_flash(:info, "Lesson updated successfully.")
        |> redirect(to: lesson_path(conn, :show, lesson))
      {:error, %Ecto.Changeset{} = changeset} ->
        Helper.render_lessons(conn, "edit_page.html", %{lesson: lesson, page: page, changeset: changeset})
    end
  end
end
