defmodule PhxVirtualScroll.Repo do
  use Ecto.Repo,
    otp_app: :phx_virtual_scroll,
    adapter: Ecto.Adapters.Postgres
end
