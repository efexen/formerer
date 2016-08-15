defmodule Formerer.SubmissionCreatorTest do
  use Formerer.ActionCase
  import ExUnit.CaptureIO

  alias Formerer.{SubmissionFactory, FormFactory, SubmissionCreator, Submission}

  setup do
    form = FormFactory.insert(:form)
    { :ok, form: form }
  end

  describe ".create" do

    test "creating submission returns ok result", %{ form: form } do
      submission_attributes = SubmissionFactory.params_with_assocs(:submission, form_id: form.id)

      changeset = Submission.changeset(%Submission{}, submission_attributes)

      { result, submission } = SubmissionCreator.create(form, changeset)

      assert result == :ok
    end

    test "successfully creating a submission triggers integrations", %{ form: form } do
      submission_attributes = SubmissionFactory.params_with_assocs(:submission, form_id: form.id)
      changeset = Submission.changeset(%Submission{}, submission_attributes)

      form = Map.put(form, :integrations, [:test])

      assert capture_io(fn ->
        SubmissionCreator.create(form, changeset)
      end) == "Submission for form #{ form.id }\n"
    end

  end

end
