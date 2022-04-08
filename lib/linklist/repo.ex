defmodule Linklist.Repo do
  use Ecto.Repo,
    otp_app: :linklist,
    adapter: Ecto.Adapters.Postgres
end
