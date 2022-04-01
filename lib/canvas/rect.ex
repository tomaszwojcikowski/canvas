defmodule Canvas.Rect do
  alias Canvas.Area

  defstruct [:height, :width, :outline, :fill]

  @type height() :: non_neg_integer()
  @type width() :: non_neg_integer()
  @type ascii() :: char()

  @type t() :: %__MODULE__{
          height: height(),
          width: width(),
          outline: ascii() | nil,
          fill: ascii() | nil
        }

  @spec new(height(), width(), ascii() | nil, ascii() | nil) :: Canvas.Rect.t()
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

  @spec draw(Area.t(), t(), Area.pos(), Area.pos()) :: Area.t()
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

  # draw only outline if h or w is small
  def draw(area, %__MODULE__{width: w, height: h} = rect, x, y)
      when h <= 2 or w <= 2 do
    draw_outline(area, x, y, rect.height, rect.width, rect.outline)
  end

  def draw(area, %__MODULE__{fill: fill, outline: outline} = rect, x, y)
      when fill != nil and outline != nil do
    area
    |> draw_outline(x, y, rect.height, rect.width, outline)
    |> draw_fill(x + 1, y + 1, rect.height - 2, rect.width - 2, fill)
  end

  @spec draw_fill(Area.t(), Area.pos(), Area.pos(), height(), width(), ascii()) :: Area.t()
  def draw_fill(area, x, y, height, width, fill) do
    y..(y + height - 1)
    |> Enum.reduce(area, fn j, ar ->
      ar |> Area.draw_horizontal(x, j, width, fill)
    end)
  end

  @spec draw_outline(Canvas.Area.t(), Area.pos(), Area.pos(), height(), width(), ascii()) ::
          Area.t()

  def draw_outline(area, x, y, 1, width, outline) do
    area
    |> Area.draw_horizontal(x, y, width, outline)
  end

  def draw_outline(area, x, y, height, 1, outline) do
    area
    |> Area.draw_vertical(x, y, height, outline)
  end

  def draw_outline(area, x, y, height, width, outline) do
    area
    |> Area.draw_horizontal(x, y, width, outline)
    |> Area.draw_horizontal(x, y + height - 1, width, outline)
    |> Area.draw_vertical(x, y + 1, height - 2, outline)
    |> Area.draw_vertical(x + width - 1, y + 1, height - 2, outline)
  end
end
