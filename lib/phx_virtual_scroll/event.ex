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

    timestamps()
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

  def base, do: from(q in __MODULE__, order_by: [asc: q.event_time])

  def get_some(query \\ base()) do
    from q in query,
      limit: 100
  end

  def on_day_in_question(query \\ base()) do
    start = ~U[1984-01-02T00:00:00.000000Z]
    finish = ~U[1984-01-03T00:00:00.000000Z]

    from q in query,
      where: q.event_time > ^start and q.event_time < ^finish,
      order_by: [asc: q.event_time]
  end

  def get_page(query \\ base(), page: page, per_page: per_page) do
    Repo.all(from a in query, offset: ^(page * per_page), limit: ^per_page)
  end

  def count(query \\ base()) do
    Repo.one(from a in query, select: count())
  end
end