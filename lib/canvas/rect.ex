defmodule Canvas.Rect do
  alias Canvas.Area

  defstruct [:height, :width, :outline, :fill]

  @type t() :: %__MODULE__{
          height: pos_integer(),
          width: pos_integer(),
          outline: char() | nil,
          fill: char() | nil
        }

  def new(height, width, outline, fill)
      when (outline != nil or fill != nil) and height > 0 and width > 0 do
    %__MODULE__{
      height: height,
      width: width,
      outline: outline,
      fill: fill
    }
  end

  def new(_, _, _, _) do
    raise ArgumentError
  end

  @spec draw(Area.t(), t(), integer(), integer) :: Area.t()
  def draw(area, %__MODULE__{height: h, width: w}, x, y)
      when area.height < y + h or area.width < x + w do
    raise ArgumentError, "Rect does not fit"
  end

  def draw(area, %__MODULE__{outline: nil} = rect, x, y) do
    draw_fill(area, x, y, rect.height, rect.width, rect.fill)
  end

  def draw(area, %__MODULE__{fill: nil} = rect, x, y) do
    draw_outline(area, x, y, rect.height, rect.width, rect.outline)
  end

  def draw(area, %__MODULE__{fill: fill, outline: outline} = rect, x, y)
      when fill != nil and outline != nil do
    area
    |> draw_outline(x, y, rect.height, rect.width, outline)
    |> draw_fill(x + 1, y + 1, rect.height - 2, rect.width - 2, fill)
  end

  def draw_fill(area, x, y, height, width, fill) do
    y..(y + height - 1)
    |> Enum.reduce(area, fn j, ar ->
      ar |> Area.draw_horizontal(x, j, width, fill)
    end)
  end

  def draw_outline(area, x, y, height, width, outline) do
    area
    |> Area.draw_horizontal(x, y, width, outline)
    |> Area.draw_horizontal(x, y + height - 1, width, outline)
    |> Area.draw_vertical(x, y + 1, height - 2, outline)
    |> Area.draw_vertical(x + width - 1, y + 1, height - 2, outline)
  end
end
