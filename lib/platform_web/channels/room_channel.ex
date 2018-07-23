defmodule PlatformWeb.RoomChannel do
  use Phoenix.Channel

  alias Platform.Lessons

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("delete_page_event", %{"page_id" => page_id}, socket) do
    page_type = Lessons.get_page!(page_id).type
    page_lesson_id = Lessons.get_page!(page_id).lesson_id

    case Lessons.delete_page(Lessons.get_page!(page_id)) do
      {:ok, _} ->
        Lessons.update_pages_order_on_delete(page_type, page_lesson_id)

        push socket, "delete_page_event", %{status: "ok"}
      {:error, _} ->
        IO.puts "************* ERROR DELETING PAGE!!! *************"
    end

    {:noreply, socket}
  end

  def handle_in("edit_page_event", %{"page_id" => page_id}, socket) do
    push socket, "edit_page_event", %{page_id: page_id}
    {:noreply, socket}
  end

  def handle_in("click_select_page_event", %{"page_id" => page_id}, socket) do
    page = Lessons.get_page!(page_id)
    push socket, "click_select_page_event",
      %{page_titles: page.titles, page_contents: page.content, page_answers: page.answers}
    {:noreply, socket}
  end

  def handle_in("load_lesson_page_event", %{"page_id" => page_id}, socket) do
    page = Lessons.get_page!(page_id)
    push socket, "load_lesson_page_event",
      %{page_titles: page.titles, page_contents: page.content, page_answers: page.answers}

    {:noreply, socket}
  end
end
