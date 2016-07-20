defmodule Formerer.FormFactory do
  use ExMachina.Ecto, repo: Formerer.Repo

  alias Formerer.{Form, UserFactory}

  def form_factory do
    %Form{
      name: sequence(:name, &"Test Form ##{&1}"),
      user: UserFactory.build(:user),
      identifier: sequence(:identifier, &"identifier#{&1}")
    }
  end

end
