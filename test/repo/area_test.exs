defmodule Canvas.AreaRepoTest do
  use Canvas.DataCase

  test "create empty" do
    model =
      Canvas.Area.new(1, 1)
      |> Canvas.Areas.create()

    assert "[[null]]" == model.content
    assert is_binary(model.uuid)
  end

  test "draw and create" do
    rect = Canvas.Rect.new(3, 3, ?a, ?b)

    model =
      Canvas.Area.new(4, 4)
      |> Canvas.Area.draw(rect, 0, 0)
      |> Canvas.Areas.create()

    assert "[[97,97,97,null],[97,98,97,null],[97,97,97,null],[null,null,null,null]]" ==
             model.content

    assert is_binary(model.uuid)
  end

  test "create and load" do
    rect = Canvas.Rect.new(3, 3, ?a, ?b)

    model =
      Canvas.Area.new(5, 4)
      |> Canvas.Area.draw(rect, 0, 0)
      |> Canvas.Areas.create()

    assert is_binary(model.uuid)

    {:ok, area} = Canvas.Areas.get_by_uuid(model.uuid)
    assert 5 = area.height
    assert 4 = area.width

    assert [
             [97, 97, 97, nil],
             [97, 98, 97, nil],
             [97, 97, 97, nil],
             [nil, nil, nil, nil],
             [nil, nil, nil, nil]
           ] = Canvas.Area.to_list(area)
  end
end
