# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhxVirtualScroll.Repo.insert!(%PhxVirtualScroll.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias PhxVirtualScroll.Event
alias PhxVirtualScroll.Repo

Repo.start_link()
Repo.delete_all(Event)

events =
  for s <- 0..86399 do
    event_time = DateTime.new!(~D[1984-01-02], Time.from_seconds_after_midnight(s))

    label = Randomizer.generate!(100, :numeric)

    cheese =
      case :rand.uniform(4) do
        1 -> "brie"
        2 -> "double cream brie"
        3 -> "triple cream brie"
        4 -> "queso"
      end

    colour =
      case :rand.uniform(4) do
        1 -> "blue"
        2 -> "green"
        3 -> "red"
        4 -> "yellow"
      end

    wen =
      case :rand.uniform(2) do
       1 -> "now"
       2 -> "then"
      end

    aspect =
      case :rand.uniform(4) do
        1 -> "north"
        2 -> "south"
        3 -> "east"
        4 -> "west"
      end

    weight = :rand.uniform(200)
    severity = :rand.uniform(5)

    %{event_time: event_time, label: label, cheese: cheese, colour: colour, aspect: aspect, when: wen, weight: weight, severity: severity}
  end

events
|> Enum.chunk_every(1000)
|> Enum.each(&Repo.insert_all(Event, &1))

Repo.stop()
