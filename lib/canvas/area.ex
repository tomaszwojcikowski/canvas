defmodule Canvas.Area do
  defstruct [:height, :width, :content]

  @type t() :: %__MODULE__{
          height: pos_integer(),
          width: pos_integer(),
          content: Arrays.array()
        }

  @type pos() :: non_neg_integer()

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

  @spec draw(any, Canvas.Rect.t(), pos(), pos()) :: t()
  def draw(area, rect, x, y) do
    Canvas.Rect.draw(area, rect, x, y)
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



  def to_list(area) do
    area.content
    |> Enum.to_list()
    |> Enum.map(&Enum.to_list(&1))
  end
end
