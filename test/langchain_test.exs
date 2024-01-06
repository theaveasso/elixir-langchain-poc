defmodule LangchainTest do
  use ExUnit.Case
  doctest Langchain

  test "greets the world" do
    assert Langchain.hello() == :world
  end
end
