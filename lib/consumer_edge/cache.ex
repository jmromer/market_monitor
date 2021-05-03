defmodule ConsumerEdge.Cache do
  @moduledoc nil

  use Nebulex.Cache,
    otp_app: :consumer_edge,
    adapter: Nebulex.Adapters.Local
end
