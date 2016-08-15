defmodule Formerer.SubmissionTest do
  use Formerer.ModelCase

  alias Formerer.Submission

  @valid_attrs %{fields: %{}, ip_address: "some content", form_id: 0}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Submission.changeset(%Submission{}, @valid_attrs)
    IO.inspect changeset
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Submission.changeset(%Submission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
