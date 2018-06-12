defmodule Platform.Helper do
  @moduledoc """
  Helper functions
  """

  alias PlatformWeb.{StudentPageView, TeacherPageView}

  def render_main_page_by_role(conn, template) do
    # Check if it is teacher or student
    case conn.assigns.current_user.role do
       "student" ->
         Phoenix.Controller.render(conn, StudentPageView, template)
       "teacher" ->
         Phoenix.Controller.render(conn, TeacherPageView, template)
    end
  end
end
