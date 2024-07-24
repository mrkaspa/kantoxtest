defmodule Kantox.Checkout.RuleLoader do
  use GenServer
  alias Kantox.Checkout.Rule

  @table_name :rules

  def start_link(file) do
    GenServer.start_link(__MODULE__, [file: file], name: __MODULE__)
  end

  @impl true
  def init(file: file) do
    :ets.new(@table_name, [:set, :protected, :named_table])

    {:ok, %{file: file}, {:continue, :init_rules}}
  end

  @impl true
  def handle_continue(:init_rules, %{file: file} = state) do
    # fetchs the file with the rules
    rules =
      File.read!(file)
      |> String.split("\n")
      |> Enum.filter(&(String.trim(&1) != ""))
      |> Enum.map(&String.split(&1, "/\\"))

    rules
    |> Rule.compile_rules()
    |> Rule.store_rules()

    {:noreply, state}
  end
end
