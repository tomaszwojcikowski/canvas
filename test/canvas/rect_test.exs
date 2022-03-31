defmodule Canvas.RectTest do
  use ExUnit.Case, async: true

  test "new rect" do
    rect = Canvas.Rect.new(2, 3, 'a', 'b')
    assert %Canvas.Rect{fill: 'b', height: 2, outline: 'a', width: 3} = rect
  end

  test "rect negative" do
    assert_raise ArgumentError, fn -> Canvas.Rect.new(-1, 3, 'a', 'b') end
    assert_raise ArgumentError, fn -> Canvas.Rect.new(2, 3, nil, nil) end
  end
end
