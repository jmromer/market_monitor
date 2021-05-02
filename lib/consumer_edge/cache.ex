defmodule ConsumerEdge.Cache do
  use Nebulex.Cache,
    otp_app: :consumer_edge,
    adapter: Nebulex.Adapters.Local
end
