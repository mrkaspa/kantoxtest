defmodule Kantox.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Kantox.Checkout.RuleLoader, "rules.txt"}
    ]

    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
