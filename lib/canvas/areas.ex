defmodule Canvas.Areas do
  @moduledoc """
  Save and load Areas
  """

  alias Canvas.Models.Area

  @spec create!(%{
          :content => String.t(),
          :height => pos_integer(),
          :width => pos_integer(),
          optional(any) => any
        }) :: Canvas.Models.Area.t()

  def create!(area) do
    params = %{content: encode_content(area), height: area.height, width: area.width}

    %Area{}
    |> Area.changeset(params)
    |> Canvas.Repo.insert!()
  end

  @spec create(Canvas.Area.t()) :: {:ok, Canvas.Models.Area.t()} | {:error, any}
  def create(area) do
    params = %{content: encode_content(area), height: area.height, width: area.width}

    %Area{}
    |> Area.changeset(params)
    |> Canvas.Repo.insert()
  end

  defp encode_content(area) do
    area |> Canvas.Area.to_list() |> Jason.encode!()
  end

  defp decode_content(content) do
    content |> Jason.decode!() |> Canvas.Area.content_from_list()
  end

  @spec get_by_uuid(String.t()) :: {:error, :not_found} | {:ok, Canvas.Area.t()}
  def get_by_uuid(uuid) do
    case Canvas.Repo.get(Area, uuid) do
      nil ->
        {:error, :not_found}

      a ->
        array = a.content |> decode_content()
        {:ok, Canvas.Area.new(a.height, a.width, array)}
    end
  end
end
