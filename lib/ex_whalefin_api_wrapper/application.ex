defmodule ExWhalefinApiWrapper.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Finch, name: FincHTTP}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
