defmodule Formerer.Integration.Slack do
  @behaviour Formerer.Integration

  import Formerer.ColumnFormatter, only: [pretty_column_name: 1]
  import Formerer.SubmissionsView, only: [all_fields: 1]

  def notify(form, submission) do
    HTTPotion.post(url(form), [body: payload(form, submission), stream_to: self])
  end

  defp payload(form, submission) do
    Poison.encode!(%{
      text: payload_text(form),
      attachments: [%{
        fields: fields(submission)
      }]
    })
  end

  defp payload_text(form) do
    "New submission for Form - " <> clean_name(form)
  end

  defp clean_name(form) do
    String.strip(form.name)
  end

  defp fields(submission) do
    all_fields(submission)
    |> Enum.map(&(format_field(&1)))
    |> Enum.sort_by(&(&1[:short]))
    |> Enum.reverse
  end

  defp format_field({key, value}) do
    %{
      title: pretty_column_name(key),
      value: value,
      short: short_value?(value)
    }
  end

  defp short_value?(value) when is_binary(value) do
    String.length(value) < 30
  end

  defp short_value?(_value) do
    true
  end

  defp url(_form) do
    base_url <> "TEST_TOKEN"
  end

  defp base_url do
    "https://hooks.slack.com/services/"
  end

end
