defmodule Canvas.Repo.Migrations.CreateAreaTable do
  use Ecto.Migration

  def change do
    create table("area") do
      add :uuid, :uuid, primary_key: true
      add(:content, :string)
      add(:height, :integer)
      add(:width, :integer)
      timestamps(type: :utc_datetime)
    end
  end
end
