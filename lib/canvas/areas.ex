defmodule Canvas.Areas do
  alias Canvas.Modules.Area

  def create(area) do
    params = %{content: encode_content(area), height: area.height, width: area.width}

    %Area{}
    |> Area.changeset(params)
    |> Canvas.Repo.insert!()
  end

  defp encode_content(area) do
    area |> Canvas.Area.to_list() |> Jason.encode!()
  end

  defp decode_content(content) do
    content |> Jason.decode!() |> Canvas.Area.content_from_list()
  end

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
