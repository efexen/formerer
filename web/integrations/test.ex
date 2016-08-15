defmodule Formerer.Integration.Test do
  @behaviour Formerer.Integration

  def notify(form, _submission) do
    IO.puts "Submission for form #{ form.id }"
  end

end
