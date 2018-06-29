defmodule Platform.Helper do
  @moduledoc """
  Helper functions
  """

  alias PlatformWeb.{StudentPageView, TeacherPageView}
  alias PlatformWeb.{AdminLessonView, StudentLessonView, TeacherLessonView}

  def render_main_page(conn, template) do
    # Check if it is teacher or student
    case conn.assigns.current_user.role do
       "student" ->
         Phoenix.Controller.render(conn, StudentPageView, template)
       "teacher" ->
         Phoenix.Controller.render(conn, TeacherPageView, template)
    end
  end

  def render_lessons(conn, template, params) do
    if conn.assigns.current_user.is_admin || conn.assigns.current_user.is_moderator do
      Phoenix.Controller.render(conn, AdminLessonView, template, params)
    else
      case conn.assigns.current_user.role do
         "student" ->
           Phoenix.Controller.render(conn, StudentLessonView, template, params)
         "teacher" ->
           Phoenix.Controller.render(conn, TeacherLessonView, template, params)
      end
    end
  end
end
