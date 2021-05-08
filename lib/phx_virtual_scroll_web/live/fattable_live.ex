defmodule PhxVirtualScrollWeb.FattableLive do
  use PhxVirtualScrollWeb, :live_view
  alias PhxVirtualScroll.Event

  @records_per_page 100
  @row_height 65

  @impl true
  def mount(_params, _session, socket) do
    events =
      Event.on_day_in_question()
      |> Event.get_page(0, @records_per_page)

    {:ok,
     assign(socket,
       records_count: Event.count(Event.on_day_in_question()),
       row_height: @row_height,
       events: events,
       fields: [:event_time, :label, :cheese, :colour, :aspect, :when, :weight, :severity]
     ), temporary_assigns: [records: []]}
  end

  def handle_event(
        "load-table",
        %{"offset" => offset},
        socket
      ) do
    {:noreply,
     socket
     |> push_event(
       "fattable-receive-table-#{offset}",
       %{
         offset: offset,
         html:
           Event.on_day_in_question()
           |> Event.get_page(offset, @records_per_page)
           |> Enum.map(fn event ->
             render_to_string(PhxVirtualScrollWeb.LayoutView, "record.html",
               conn: socket,
               event: event
             )
           end)
       }
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
            <div  data-max-height="300" data-follow="false">
              <table class="w-full divide-y divide-gray-200 relative">
                <thead class="bg-gray-50">
                  <%= render_table_header(fields: @fields) %>
                </thead>
                <tbody id="fattable" phx-hook="Fattable">
                  <%= for event <- @events do %>
                    <%= render(PhxVirtualScrollWeb.LayoutView, "event.html", conn: @socket, event: event, fields: @fields) %>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </div>
    </div>


    <div id="loading-block" style="display: none" aria-hidden="true">
  <div class="record">
    Loading...
  </div>
</div>
    """
  end

  defp render_table_header(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <tr class="h-12">
      <%= for field <- @fields do %>
        <td class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
          <div class="flex items-center">
            <%= Atom.to_string(field) %>
          </div>
        </td>
      <% end %>
    </tr>
    """
  end
end
