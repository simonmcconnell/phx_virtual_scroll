defmodule PhxVirtualScrollWeb.StaticListLive do
  use PhxVirtualScrollWeb, :live_view
  alias PhxVirtualScroll.Event

  @impl true
  def mount(_params, _session, socket) do
    events = Event.on_day_in_question() |> Event.limit(100) |> Event.get()

    {:ok,
     assign(socket,
       events: events,
       fields: [:event_time, :label, :cheese, :colour, :aspect, :when, :weight, :severity]
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="h-screen w-screen overflow-hidden bg-white">
      <div class="relative w-full h-full">

        <div class="flex flex-col h-full">
          <!-- top section -->
          <div class="h-24 bg-gray-100 flex-none">
            <div class="h-12 bg-gray-300">Events</div>
            <div class="h-12 bg-gray-200">...</div>
          </div>

          <!-- bottom section -->
          <div class="flex-grow overflow-x-auto overflow-y-hidden">
            <!-- table -->
            <div class="table w-full divide-y divide-gray-200">
              <div class="table-header-group bg-gray-50">
                <%= render_table_header(fields: @fields) %>
              </div>
              <div class="table-row-group divide-y divide-gray-100">
                <%= render_rows(events: @events, fields: @fields) %>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
    """
  end

  defp render_table_header(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <div class="table-row h-12">
      <%= for field <- @fields do %>
        <div class="table-cell px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
          <div class="flex items-center">
            <%= Atom.to_string(field) %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp render_rows(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <%= for event <- @events do %>
      <div id="event-<%= event.id %>" class="table-row bg-white hover:bg-gray-50">
        <%= for field <- @fields do %>
          <div class="table-cell px-6 py-2 whitespace-nowrap text-sm text-gray-500">
            <%= Map.get(event, field) %>
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end
end
