defmodule Canvas.AreaTest do
  use ExUnit.Case, async: true

  test "new 1x1" do
    %Canvas.Area{content: content, height: 1, width: 1} = Canvas.Area.new(1, 1)
    assert [_] = content |> Arrays.to_list()
    assert [nil] = content[0] |> Arrays.to_list()
  end

  test "draw simple" do
    rect = Canvas.Rect.new(2, 2, nil, 'a')
    area = Canvas.Area.new(3, 3)

    [['a', 'a', nil], ['a', 'a', nil], ['a', 'a', nil]] =
      Canvas.Area.draw(area, 0, 0, rect) |> Canvas.Area.to_list()
  end

  test "draw outline" do
    rect = Canvas.Rect.new(3, 3, 'b', nil)
    area = Canvas.Area.new(4, 4)
    area2 = Canvas.Area.draw(area, 0, 0, rect)

    [['b', 'b', 'b', nil], ['b', nil, 'b', nil], ['b', 'b', 'b', nil], [nil, nil, nil, nil]] =
      area2 |> Canvas.Area.to_list()
  end

  test "draw outline and fill" do
    rect = Canvas.Rect.new(3, 3, 'a', 'b')
    area = Canvas.Area.new(4, 4)
    area2 = Canvas.Area.draw(area, 0, 0, rect)

    [['a', 'a', 'a', nil], ['a', 'b', 'a', nil], ['a', 'a', 'a', nil], [nil, nil, nil, nil]] =
      area2 |> Canvas.Area.to_list()
  end
end
