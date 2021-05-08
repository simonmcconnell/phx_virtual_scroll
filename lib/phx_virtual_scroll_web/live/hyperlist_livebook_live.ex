defmodule PhxVirtualScrollWeb.HyperlistLivebookLive do
  use PhxVirtualScrollWeb, :live_view
  alias PhxVirtualScroll.Event

  @impl true
  def mount(_params, _session, socket) do
    # events =
    #   Event.on_day_in_question()
    #   |> Event.limit(page_size)
    #   |> Event.get()

    page_size = 100
    total = Event.on_day_in_question() |> Event.count()
    url = PhxVirtualScrollWeb.Router.Helpers.url(socket)

    {:ok,
     assign(socket,
       #  events: events,
       total: total,
       page_size: page_size,
       url: url,
       fields: [:event_time, :label, :cheese, :colour, :aspect, :when, :weight, :severity]
     )}
  end

  @impl true
  def handle_event("load-events", %{"page" => page, "page_size" => page_size} = params, socket) do
    IO.puts("handling load-events")
    IO.inspect(params)

    events =
      Event.on_day_in_question()
      |> Event.get_page(page, page_size)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))

    {:noreply,
     socket
     |> push_event("receive-events-#{page}", %{events: events})}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="h-screen w-screen bg-white">
      <div class="w-full h-full">
          <!-- bottom section -->
          <!-- <div class="flex-grow"> -->
        <div id="hyperlist1" class="h-full w-full" phx-hook="HyperlistLivebook" data-url="<%= @url %>" data-max-height="400" data-line-height="40" data-page-size="<%= @page_size %>" data-total="<%= @total %>">
            <div data-fields class="hidden">
              <%= for field <- @fields do %>
                <span data-field="<%= field %>"></span>
              <% end %>
            </div>
          <table class="w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <%= render_table_header(fields: @fields) %>
            </thead>
            <tbody data-content phx-update="ignore" class="overflow-auto relative divide-y divide-gray-100">
            </tbody>
            </table>

        </div>
            <!-- table -->


        </div>
      </div>
    </div>
    """
  end

  # <!-- top section -->
  #   <div class="h-24 bg-gray-100 flex-none">
  #     <div class="h-12 bg-gray-300">Events</div>
  #     <div class="h-12 bg-gray-200">...</div>
  #   </div>

  # <div id="hyperlist" phx-hook="HyperlistLivebook" data-max-height="300" data-follow="false">

  #           </div>
  #         </div>

  #   <tbody data-template class="hidden">
  #   <%= for event <- @events do %>
  #     <tr id="event-<%= event.id %>" class="bg-white hover:bg-gray-50">
  #       <%= for field <- @fields do %>
  #         <div class="px-6 py-2 whitespace-nowrap text-sm text-gray-500">
  #           <%= Map.get(event, field) %>
  #         </div>
  #       <% end %>
  #     </tr>
  #   <% end %>
  # </tbody>

  defp render_table_header(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <tr class="h-12">
      <%= for field <- @fields do %>
        <th class="sticky top-0 px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
          <div class="flex items-center">
            <%= Atom.to_string(field) %>
          </div>
        </th>
      <% end %>
    </tr>
    """
  end
end
