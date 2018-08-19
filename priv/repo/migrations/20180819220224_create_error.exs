defmodule ErrorHandler.Repo.Migrations.CreateError do
  use Ecto.Migration

  def change do
    create table(:errors) do
      add :text, :text, null: false
    end
  end
end
