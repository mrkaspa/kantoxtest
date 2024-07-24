defmodule Kantox.Checkout.CartTest do
  use ExUnit.Case
  alias Kantox.Checkout.Cart

  test "adding two green tea" do
    cart =
      Cart.new()
      |> Cart.add("GR1", 1)
      |> Cart.add("GR1", 1)

    assert %{"GR1" => {_, 2}} = cart.products
    assert cart.total == 3.11
  end

  test "adding three green tea one strawberry and one coffee" do
    cart =
      Cart.new()
      |> Cart.add("GR1", 1)
      |> Cart.add("SR1", 1)
      |> Cart.add("GR1", 1)
      |> Cart.add("GR1", 1)
      |> Cart.add("CF1", 1)

    assert %{"GR1" => {_, 3}, "SR1" => {_, 1}, "CF1" => {_, 1}} = cart.products
    assert cart.total == 22.45
  end

  test "adding one green tea three strawberry and one coffee" do
    cart =
      Cart.new()
      |> Cart.add("SR1", 1)
      |> Cart.add("SR1", 1)
      |> Cart.add("GR1", 1)
      |> Cart.add("SR1", 1)

    assert %{"GR1" => {_, 1}, "SR1" => {_, 3}} = cart.products
    assert cart.total == 16.61
  end

  test "adding one green tea one strawberry and three coffee" do
    cart =
      Cart.new()
      |> Cart.add("GR1", 1)
      |> Cart.add("CF1", 1)
      |> Cart.add("SR1", 1)
      |> Cart.add("CF1", 1)
      |> Cart.add("CF1", 1)

    assert %{"GR1" => {_, 1}, "SR1" => {_, 1}, "CF1" => {_, 3}} = cart.products
    assert cart.total == 30.57
  end
end
