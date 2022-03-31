defmodule Canvas.Area do
  defstruct [:height, :width, :content]

  @type t() :: %__MODULE__{
          height: pos_integer(),
          width: pos_integer(),
          content: Arrays.array()
        }

  @spec new(pos_integer(), pos_integer()) :: Canvas.Area.t()
  def new(height, width) when height > 0 and width > 0 do
    %__MODULE__{
      height: height,
      width: width,
      content: init_content(height, width)
    }
  end

  defp init_content(height, width) do
    List.duplicate(nil, width)
    |> Enum.into(Arrays.new())
    |> List.duplicate(height)
    |> Enum.into(Arrays.new())
  end

  @spec draw(t(), pos_integer(), pos_integer(), Canvas.Rect.t()) :: t()
  def draw(area, x, y, %Canvas.Rect{outline: nil} = rect) do
    draw_fill(area, x, y, rect.height, rect.width, rect.fill)
  end

  def draw(area, x, y, %Canvas.Rect{fill: nil} = rect) do
    draw_outline(area, x, y, rect.height, rect.width, rect.outline)
  end

  def draw(area, x, y, %Canvas.Rect{fill: fill, outline: outline} = rect)
      when fill != nil and outline != nil do
    area
    |> draw_outline(x, y, rect.height, rect.width, outline)
    |> draw_fill(x + 1, y + 1, rect.height - 2, rect.width - 2, fill)
  end

  @spec draw_horizontal(t(), integer, integer, integer, char()) :: t()
  def draw_horizontal(canvas, x, y, width, fill) do
    x..(x + width - 1)
    |> Enum.reduce(canvas, fn i, canv ->
      new_x_array = canv.content[y] |> Arrays.replace(i, fill)
      %{canv | content: canv.content |> Arrays.replace(y, new_x_array)}
    end)
  end

  def draw_vertical(area, x, y, height, fill) do
    y..(y + height - 1)
    |> Enum.reduce(area, fn j, ar ->
      draw_horizontal(ar, x, j, 1, fill)
    end)
  end

  def draw_fill(area, x, y, height, width, fill) do
    y..(y + height - 1)
    |> Enum.reduce(area, fn j, ar ->
      ar |> draw_horizontal(x, j, width, fill)
    end)
  end

  @spec draw_outline(t(), integer(), integer(), pos_integer(), pos_integer(), char()) :: t()
  def draw_outline(area, x, y, height, width, outline) do
    area
    |> draw_horizontal(x, y, width, outline)
    |> draw_horizontal(x, y + height - 1, width, outline)
    |> draw_vertical(x, y + 1, height - 2, outline)
    |> draw_vertical(x + width - 1, y + 1, height - 2, outline)
  end

  def to_list(area) do
    area.content
    |> Enum.to_list()
    |> Enum.map(&Enum.to_list(&1))
  end
end
