defmodule MusicbotTest do
  use ExUnit.Case
  doctest Musicbot

  test "greets the world" do
    assert Musicbot.hello() == :world
  end
end
