defmodule Formerer.ActionCase do

  use ExUnit.CaseTemplate

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Formerer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Formerer.Repo, {:shared, self()})
    end

    :ok
  end

end
