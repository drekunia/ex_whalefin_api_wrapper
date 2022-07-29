defmodule ExWhalefinApiWrapperTest do
  use ExUnit.Case
  doctest ExWhalefinApiWrapper

  test "greets the world" do
    assert ExWhalefinApiWrapper.hello() == :world
  end
end
