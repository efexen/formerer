defmodule Formerer.SubmissionCreatorTest do
  use Formerer.ActionCase

  alias Formerer.{FormFactory, SubmissionCreator, Submission}

  setup do
    form = FormFactory.create(:form)
    { :ok, form: form }
  end

  describe ".create" do

    test "creating submission returns ok result", %{ form: form } do
      changeset = Submission.changeset(%Submission{}, %{ fields: %{ name: "Tester" } })

      { result, submission } = SubmissionCreator.create(form, changeset)

      assert result == :ok
    end

  end

end
