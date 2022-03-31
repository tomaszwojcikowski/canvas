defmodule Canvas.Rect do

  defstruct [:height, :width, :outline, :fill]

  @type t() :: %__MODULE__{
    height: pos_integer(),
    width: pos_integer(),
    outline: char() | nil,
    fill: char() | nil
  }


  def new(height, width, outline, fill) when (outline != nil) or (fill != nil) do
    %__MODULE__{
      height: height,
      width: width,
      outline: outline,
      fill: fill
    }
  end



end
