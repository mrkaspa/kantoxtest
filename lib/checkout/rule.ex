defmodule Kantox.Checkout.Rule do
  @table_name :rules
  @moduledoc """
  This modules compiles and executes the rules for the prices
  """

  def compile_rules(rules_list) do
    Enum.map(rules_list, fn [sku, price_fun_str] -> {sku, compile_rule(price_fun_str)} end)
  end

  defp compile_rule(price_fun_str) do
    {:ok, fun} = Code.string_to_quoted(price_fun_str)

    fun
  end

  def store_rules(rules_list) do
    Enum.each(rules_list, fn {sku, fun} ->
      true = :ets.insert(@table_name, {sku, fun})
    end)
  end

  @doc "get the prices for a product sku and quantity"
  def get_prices(sku, price, quantity) do
    rule =
      :ets.lookup(@table_name, sku) |> List.first()

    if rule != nil do
      {_, fun_rule} = rule

      case Code.eval_quoted(fun_rule, quantity: quantity, price: price) do
        {{:ok, prices}, _} -> prices
        _ -> default_prices(price, quantity)
      end
    else
      default_prices(price, quantity)
    end
  end

  def default_prices(price, quantity) do
    Enum.map(1..quantity, fn _ -> price end)
  end
end
