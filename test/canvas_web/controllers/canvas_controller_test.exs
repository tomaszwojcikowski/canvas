defmodule CanvasWeb.CanvasControllerTest do
  use CanvasWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.canvas_path(conn, :index))
    assert conn.resp_body =~ "\n"
  end

  test "PUT empty", %{conn: conn} do
    conn = post(conn, Routes.canvas_path(conn, :create), %{"rects" => []})
    assert conn.resp_body =~ ""
  end

  test "PUT and GET simple", %{conn: conn} do
    rect = %{
      height: 5,
      width: 6,
      outline: "%",
      fill: "&",
      x: 1,
      y: 2
    }

    conn = post(conn, Routes.canvas_path(conn, :create), %{"rects" => [rect]})
    id = conn.resp_body

    conn = get(conn, Routes.canvas_path(conn, :show, id))
    assert "\n\n %%%%%%\n %&&&&%\n %&&&&%\n %&&&&%\n %%%%%%" == conn.resp_body
  end

  test "GET existing", %{conn: conn} do
    rect = Canvas.Rect.new(3, 3, ?a, ?b)
    rect2 = Canvas.Rect.new(2, 2, ?c, ?d)

    model =
      Canvas.Area.new(10, 10)
      |> Canvas.Area.draw(rect, 0, 0)
      |> Canvas.Area.draw(rect2, 5, 5)
      |> Canvas.Areas.create!()

    conn = get(conn, Routes.canvas_path(conn, :show, model.uuid))
    assert text_response(conn, 200)
  end
end
