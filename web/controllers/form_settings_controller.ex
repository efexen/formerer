defmodule Formerer.FormSettingsController do
  use Formerer.Web, :controller

  def edit(conn, %{"form_id" => id}) do
    render conn
  end

end
