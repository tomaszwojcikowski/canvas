defmodule AreaTest do
  use ExUnit.Case, async: true

  alias Canvas.Area
  alias Canvas.Rect

  test "new 1x1" do
    %Area{content: content, height: 1, width: 1} = Area.new(1, 1)
    assert [_] = content |> Arrays.to_list()
    assert [nil] = content[0] |> Arrays.to_list()
  end

  test "draw 1x1" do
    area = Area.new(5, 5)
    rect = Rect.new(1, 1, nil, 'c')
    assert "     \n     \n  c  \n     \n     " == Area.draw(area, rect, 2, 2) |> Area.to_ascii()
  end

  test "draw simple" do
    rect = Rect.new(2, 2, nil, 'a')
    area = Area.new(3, 3)

    [['a', 'a', nil], ['a', 'a', nil], [nil, nil, nil]] =
      Area.draw(area, rect, 0, 0) |> Area.to_list()
  end

  test "draw outline" do
    rect = Rect.new(3, 3, 'b', nil)
    area = Area.new(4, 4)
    area2 = Area.draw(area, rect, 0, 0)

    [['b', 'b', 'b', nil], ['b', nil, 'b', nil], ['b', 'b', 'b', nil], [nil, nil, nil, nil]] =
      area2 |> Area.to_list()
  end

  test "draw outline and fill" do
    rect = Rect.new(3, 3, 'a', 'b')
    area = Area.new(4, 4)
    area2 = Area.draw(area, rect, 0, 0)

    ascii = area2 |> Area.to_ascii()

    assert ascii ==
             "aaa \naba \naaa \n    "
  end

  describe "failures" do
    test "negative area" do
      assert_raise ArgumentError, fn -> Area.new(0, -1) end
    end

    test "negative rect" do
      area = Area.new(4, 4)
      rect = Rect.new(1, 2, 'a', nil)
      assert_raise ArgumentError, fn -> Area.draw(area, rect, -1, -2) end
    end

    test "rect to big" do
      area = Area.new(2, 2)
      rect = Rect.new(3, 4, 'a', nil)
      assert_raise ArgumentError, fn -> Area.draw(area, rect, 0, 0) |> Area.to_list() end
    end

  end
end
