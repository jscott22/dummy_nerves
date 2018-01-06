defmodule DummyNervesTest do
  use ExUnit.Case
  doctest DummyNerves

  test "greets the world" do
    assert DummyNerves.hello() == :world
  end
end
