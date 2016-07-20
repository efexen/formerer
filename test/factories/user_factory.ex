defmodule Formerer.UserFactory do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  use ExMachina.Ecto, repo: Formerer.Repo

  alias Formerer.User

  def user_factory do
    %User{
      email: sequence(:email, &"email#{&1}@example.com"),
      password_digest: hashpwsalt("ins3cure"),
      activated: true,
      token: "usertoken",
      activated_at: Timex.DateTime.now
    }
  end

end
