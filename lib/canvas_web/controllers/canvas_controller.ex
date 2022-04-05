defmodule CanvasWeb.CanvasController do
  use CanvasWeb, :controller

  def index(conn, _) do
    :rand.uniform()
    rect = Canvas.Rect.new(:rand.uniform(20), :rand.uniform(20), ?o, ?f)

    area =
      Canvas.Area.new()
      |> Canvas.Area.draw(rect, 2, 2)

    text(conn, Canvas.Area.to_ascii(area))
  end

  def create(conn, %{"rects" => rects_def}) do
    area = Canvas.Area.new()

    area2 =
      Enum.reduce(rects_def, area, fn r, ar ->
        r = parse_rect(r)
        rect = Canvas.Rect.new(r[:height], r[:width], r[:outline], r[:fill])
        Canvas.Area.draw(ar, rect, r[:x], r[:y])
      end)

    m_area = Canvas.Areas.create!(area2)

    text(conn, m_area.uuid)
  end

  defp parse_rect(r) do
    [
      height: r["height"],
      width: r["width"],
      outline: String.to_charlist(r["outline"]),
      fill: String.to_charlist(r["fill"]),
      x: r["x"],
      y: r["y"]
    ]
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case Canvas.Areas.get_by_uuid(id) do
      {:ok, area} ->
        text(conn, Canvas.Area.to_ascii(area))

      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(CanvasWeb.ErrorView)
        |> put_resp_content_type("text/plain")
        |> render(:"404")
    end
  end
end
