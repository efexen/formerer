defmodule Formerer.SubmissionFactory do
  use ExMachina.Ecto, repo: Formerer.Repo

  alias Formerer.{Submission, FormFactory}

  def submission_factory do
    %Submission{
      ip_address: "127.0.0.1",
      form: FormFactory.build(:form),
      fields: %{}
    }
  end

end
