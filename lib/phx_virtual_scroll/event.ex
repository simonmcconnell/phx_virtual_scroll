defmodule PhxVirtualScroll.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias PhxVirtualScroll.Repo

  schema "events" do
    field :event_time, :utc_datetime
    field :label, :string
    field :cheese, :string
    field :colour, :string
    field :aspect, :string
    field :when, :string
    field :weight, :integer
    field :severity, :integer
  end

  @fields [
    :event_time,
    :label,
    :cheese,
    :colour,
    :aspect,
    :when,
    :weight,
    :severity
  ]

  @required_fields [
    :event_time,
    :cheese
  ]

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def get(query) do
    Repo.all(query)
  end

  def base, do: __MODULE__

  def limit(query \\ base(), limit) do
    from q in query, limit: ^limit
  end

  def on_day_in_question(query \\ base()) do
    start = ~U[1984-01-02T00:00:00.000000Z]
    finish = ~U[1984-01-03T00:00:00.000000Z]

    from q in query,
      where: q.event_time > ^start and q.event_time < ^finish
  end

  def order_by_event_time(query \\ base(), dir \\ :asc) when dir in [:asc, :desc] do
    from q in query,
      order_by: [{^dir, q.event_time}]
  end

  def get_page(query \\ base(), page, page_size) do
    Repo.all(from a in query, offset: ^(page * page_size), limit: ^page_size)
  end

  def count(query \\ base()) do
    Repo.one(from a in query, select: count())
  end
end
