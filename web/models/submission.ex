defmodule Formerer.Submission do
  use Formerer.Web, :model

  schema "submissions" do
    field :fields, :map
    field :ip_address, :string
    belongs_to :form, Formerer.Form

    timestamps
  end

  @required_fields ~w(fields ip_address form_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
