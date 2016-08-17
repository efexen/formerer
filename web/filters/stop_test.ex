defmodule Formerer.Filter.StopTest do
  @behaviour Formerer.Filter

  def filter(_form, _changeset) do
    { :stop, %{} }
  end
end
