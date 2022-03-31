defmodule Canvas.Area do
  defstruct [:height, :width, :content]

  @type t() :: %__MODULE__{
          height: pos_integer(),
          width: pos_integer(),
          content: Arrays.array()
        }

  @type pos() :: non_neg_integer()

  @spec new(pos_integer(), pos_integer()) :: Canvas.Area.t()
  def new(height, width) when height <= 0 or width <= 0 do
    raise ArgumentError, "height and width must be > 0"
  end

  def new(height, width) do
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

  @spec draw(t(), Canvas.Rect.t(), pos(), pos()) :: t()
  def draw(_area, _rect, x, y) when x < 0 or y < 0 do
    raise ArgumentError, "x and y cannot be negative"
  end

  def draw(area, rect, x, y) do
    Canvas.Rect.draw(area, rect, x, y)
  end

  @spec draw_horizontal(t(), integer, integer, integer, char()) :: t()
  def draw_horizontal(area, x, y, width, fill) do
    x..(x + width - 1)
    |> Enum.reduce(area, fn i, ar ->
      new_x_array = ar.content[y] |> Arrays.replace(i, fill)
      %{ar | content: ar.content |> Arrays.replace(y, new_x_array)}
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

  def to_ascii(area) do
    area
    |> to_list()
    |> Stream.map(fn l ->
      Enum.map(l, fn
        nil -> " "
        a -> a
      end)
    end)
    |> Stream.map(&List.to_string/1)
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.join("\n")
  end
end
