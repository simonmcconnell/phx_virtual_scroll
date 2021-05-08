defmodule PhxVirtualScrollWeb.EventView do
  use PhxVirtualScrollWeb, :view
  alias __MODULE__

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      event_time: event.event_time,
      label: event.label,
      cheese: event.cheese,
      colour: event.colour,
      aspect: event.aspect,
      when: event.when,
      weight: event.weight,
      severity: event.severity
    }
  end
end
