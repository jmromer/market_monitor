defmodule ConsumerEdge.Repo do
  use Ecto.Repo,
    otp_app: :consumer_edge,
    adapter: Ecto.Adapters.Postgres
end
