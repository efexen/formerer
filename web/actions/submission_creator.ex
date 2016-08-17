defmodule Formerer.SubmissionCreator do

  import Formerer.IntegrationNotifier, only: [notify_integrations: 2]
  import Formerer.SubmissionFilter, only: [execute_filters: 2]
  alias Formerer.Repo

  def create(form, changeset) do
    case execute_filters(form, changeset) do
      { :continue, changeset } ->
        create_submission(form, changeset)
      { :stop, changeset } ->
        { :stop, changeset }
    end
  end

  def create_submission(form, changeset) do
    result = Repo.insert(changeset)
    { status, submission } = result

    if status == :ok, do: notify_integrations(form, submission)

    result
  end

end
