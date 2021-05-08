defmodule PhxVirtualScrollWeb.EventController do
  use PhxVirtualScrollWeb, :controller

  alias PhxVirtualScroll.Event

  action_fallback PhxVirtualScrollWeb.FallbackController

  def get_page(conn, %{"page" => page, "page_size" => page_size}) do
    events =
      Event.on_day_in_question()
      |> Event.get_page(String.to_integer(page), String.to_integer(page_size))
    render(conn, "index.json", events: events)
  end
end
