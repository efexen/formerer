defmodule Formerer.Form do
  use Formerer.Web, :model

  schema "forms" do
    field :name, :string
    field :identifier, :string
    field :columns, {:array, :string}
    field :integrations, {:array, :string}
    belongs_to :user, Formerer.User

    has_many :submissions, Formerer.Submission, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name identifier)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:identifier)
  end
end
