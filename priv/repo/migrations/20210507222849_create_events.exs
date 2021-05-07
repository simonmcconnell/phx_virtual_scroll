defmodule PhxVirtualScroll.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_time, :utc_datetime
      add :label, :string
      add :cheese, :string
      add :colour, :string
      add :aspect, :string
      add :when, :string
      add :weight, :integer
      add :severity, :integer
    end

    create index(:events, [:event_time])

  end
end
