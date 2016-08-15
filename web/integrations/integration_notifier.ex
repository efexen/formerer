defmodule Formerer.IntegrationNotifier do

  alias Formerer.Form

  def notify_integrations(form, submission) do
    form.integrations
    |> Enum.each(&(notify_integration(&1, form, submission)))
  end

  defp notify_integration(integration, form, submission) do
    Application.get_env(:formerer, :integrations)[integration].notify(form, submission)
  end

end
