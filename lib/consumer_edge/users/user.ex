defmodule ConsumerEdge.Users.User do
  @moduledoc nil

  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()
  end
end
