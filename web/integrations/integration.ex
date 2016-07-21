defmodule Formerer.Integration do

  @callback notify(Formerer.Form.t, Formerer.Submission.t) :: any

end
