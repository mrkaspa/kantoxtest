defmodule Kantox.Checkout.Cart do
  alias __MODULE__
  alias Kantox.Checkout.{Product, Rule}

  @moduledoc """
  Cart module
  """

  defstruct products: %{},
            total: 0.0

  @doc "Creates a new cart"
  def new do
    %Cart{}
  end

  @doc "Adds a product to the cart anc calculates the total price"
  def add(cart, product_sku, quantity) do
    product =
      Product.list_products()
      |> Enum.find(&(&1.sku == product_sku))

    if product != nil do
      new_products =
        Map.update(
          cart.products,
          product_sku,
          {product.price, quantity},
          fn {in_cart_price, in_cart_quantity} -> {in_cart_price, in_cart_quantity + quantity} end
        )

      %{cart | products: new_products, total: calculate_total(new_products)}
    else
      cart
    end
  end

  def calculate_total(products) do
    products
    |> Enum.flat_map(fn {sku, {price, quantity}} ->
      Rule.get_prices(sku, price, quantity)
    end)
    |> Enum.reduce(0.0, &(&1 + &2))
  end
end
