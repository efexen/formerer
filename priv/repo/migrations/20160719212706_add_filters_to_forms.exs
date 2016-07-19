defmodule Formerer.Repo.Migrations.AddFiltersToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :filters, { :array, :string }, null: false, default: []
    end
  end
end
