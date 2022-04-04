defmodule Canvas.Models.Area do
  @moduledoc """
  Area model for Ecto
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "area" do
    field :content, :string
    field :height, :integer
    field :width, :integer
    timestamps(type: :utc_datetime)
  end

  def changeset(area, params \\ %{}) do
    area
    |> cast(params, [:content, :height, :width])
    |> validate_required([:content, :height, :width])
  end
end
