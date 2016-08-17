defmodule Formerer.SubmissionCreatorTest do
  use Formerer.ActionCase
  import ExUnit.CaptureIO
  import Ecto.Query

  alias Formerer.{SubmissionFactory, FormFactory, SubmissionCreator, Submission}

  setup do
    form = FormFactory.insert(:form)
    submission_attributes = SubmissionFactory.params_for(:submission, form_id: form.id)
    submission = Submission.changeset(%Submission{}, submission_attributes)

    { :ok, form: form, submission: submission }
  end

  describe ".create" do

    test "creating submission returns ok result", %{ form: form, submission: submission } do
      { result, _submission } = SubmissionCreator.create(form, submission)
      assert result == :ok
    end

    test "creating submission creates submission record for form", %{ form: form, submission: submission } do
      SubmissionCreator.create(form, submission)
      assert form_submission_count(form.id) == 1
    end

    test "successfully creating a submission triggers integrations", %{ form: form, submission: submission } do
      form = Map.put(form, :integrations, [:test])

      assert capture_io(fn ->
        SubmissionCreator.create(form, submission)
      end) == "Submission for form #{ form.id }\n"
    end

    test "filter returning false returns stop as creation result", %{ form: form, submission: submission } do
      form = Map.put(form, :filters, [:stop_test])

      { result, _submission } = SubmissionCreator.create(form, submission)
      assert result == :stop
    end

    test "filter returning false stops submission from being created", %{ form: form, submission: submission } do
      form = Map.put(form, :filters, [:stop_test])

      SubmissionCreator.create(form, submission)
      form = Map.put(form, :filters, [:test])

      assert form_submission_count(form.id) == 0
    end

  end

  defp form_submission_count(form_id) do
    query = from s in Submission, where: s.form_id == ^form_id
    Formerer.Repo.aggregate(query, :count, :id)
  end

end
