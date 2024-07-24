defmodule Kantox.Checkout.Product do
  alias __MODULE__

  @moduledoc """
  Struct to represent a Product
  """

  defstruct sku: "",
            name: "",
            price: 0.0

  def list_products() do
    [
      %Product{sku: "GR1", name: "Green tea", price: 3.11},
      %Product{sku: "SR1", name: "Strawberries", price: 5.0},
      %Product{sku: "CF1", name: "Coffee", price: 11.23}
    ]
  end
end
