defmodule Formerer.Filter do

  @callback filter(Formerer.Form.t, Ecto.Changeset.t) :: any

end
