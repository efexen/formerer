defmodule Formerer.SubmissionCreator do

  import Formerer.IntegrationNotifier, only: [notify_integrations: 2]
  alias Formerer.Repo

  def create(form, changeset) do
    result = Repo.insert(changeset)
    { status, submission } = result

    if status == :ok, do: notify_integrations(form, submission)

    result
  end

end
