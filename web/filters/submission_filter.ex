defmodule Formerer.SubmissionFilter do

  def execute_filters(form, changeset) do
    results = form.filters
    |> Enum.map(&(execute_filter(&1, form, changeset)))

    case List.keyfind(results, :stop, 0) do
      {:stop, _ } ->
        { :stop, changeset }
      nil ->
        { :continue, changeset }
    end
  end

  defp execute_filter(filter, form, changeset) do
    Application.get_env(:formerer, :filters)[filter].filter(form, changeset)
  end

end
