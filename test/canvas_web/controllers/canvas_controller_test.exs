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

  test "PUT simple", %{conn: conn} do
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
end
