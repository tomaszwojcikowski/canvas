defmodule AreaTest do
  use ExUnit.Case, async: true

  alias Canvas.Area
  alias Canvas.Rect

  describe "draw" do
    test "new 1x1" do
      %Area{content: content, height: 1, width: 1} = Area.new(1, 1)
      assert [_] = content |> Arrays.to_list()
      assert [nil] = content[0] |> Arrays.to_list()
    end

    test "draw 1x1" do
      area = Area.new(5, 5)
      rect = Rect.new(1, 1, nil, ?c)
      assert "\n\n  c" == Area.draw(area, rect, 2, 2) |> Area.to_ascii()
    end

    test "draw simple" do
      rect = Rect.new(2, 2, nil, ?a)
      area = Area.new(3, 3)

      [[?a, ?a, nil], [?a, ?a, nil], [nil, nil, nil]] =
        Area.draw(area, rect, 0, 0) |> Area.to_list()
    end

    test "draw outline" do
      rect = Rect.new(3, 3, ?b, nil)
      area = Area.new(4, 4)
      area2 = Area.draw(area, rect, 0, 0)

      [[?b, ?b, ?b, nil], [?b, nil, ?b, nil], [?b, ?b, ?b, nil], [nil, nil, nil, nil]] =
        area2 |> Area.to_list()
    end

    test "draw outline and fill" do
      rect = Rect.new(3, 3, ?a, ?b)
      area = Area.new(4, 4)
      area2 = Area.draw(area, rect, 0, 0)

      ascii = area2 |> Area.to_ascii()

      assert "aaa\naba\naaa" == ascii
    end
  end

  describe "draw multiple" do
    test "draw two small" do
      rect = Rect.new(3, 3, ?a, ?b)
      rect2 = Rect.new(2, 2, ?c, ?d)

      ascii =
        Area.new(10, 10)
        |> Area.draw(rect, 0, 0)
        |> Area.draw(rect2, 5, 5)
        |> Area.to_ascii()

      assert "aaa\naba\naaa\n\n\n     dd\n     dd" ==
               ascii
    end

    # - Rectangle at [3,2] with width: 5, height: 3, outline character: `@`, fill character: `X`
    # - Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`
    test "draw fixture 1" do
      rect = Rect.new(3, 5, '@', 'X')
      rect2 = Rect.new(6, 14, 'X', 'O')

      ascii =
        Area.new(9, 25)
        |> Area.draw(rect, 3, 2)
        |> Area.draw(rect2, 10, 3)
        |> Area.to_ascii()

      fix1 =
        [:code.priv_dir(:canvas), "fixture/fix1.txt"]
        |> Path.join()
        |> File.read!()

      assert fix1 == ascii
    end

    #     Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`
    # - Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`
    # - Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`

    test "draw fixture 2" do
      rect = Rect.new(6, 7, nil, '.')
      rect2 = Rect.new(4, 8, 'O', nil)
      rect3 = Rect.new(3, 5, 'X', 'X')

      ascii =
        Area.new(8, 22)
        |> Area.draw(rect, 14, 0)
        |> Area.draw(rect2, 0, 3)
        |> Area.draw(rect3, 5, 5)
        |> Area.to_ascii()

      fix2 =
        [:code.priv_dir(:canvas), "fixture/fix2.txt"]
        |> Path.join()
        |> File.read!()

      assert fix2 == ascii
    end
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
