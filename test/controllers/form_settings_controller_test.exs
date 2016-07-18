defmodule Formerer.FormSettingsControllerTest do
  use Formerer.ConnCase
  alias Formerer.{UserFactory, FormFactory}

  setup %{conn: conn} do
    user = UserFactory.create(:user)
    login_custom_user(conn, user)
  end

  describe "GET #edit" do

    test "user can view settings page for a form they own", %{ conn: conn, user: user } do
      form = FormFactory.create(:form, [user: user])
      conn = get(conn, form_settings_path(conn, :edit, form))

      assert html_response(conn, 200)
      assert conn.assigns[:form].id == form.id
    end

    test "user cant view settings page for other users form", %{ conn: conn, user: user } do
      form = FormFactory.create(:form)
      conn = get(conn, form_settings_path(conn, :edit, form))

      assert response(conn, 404)
    end

    test "user cant view settings page for form that doesn't exist", %{ conn: conn, user: user } do
      conn = get(conn, form_settings_path(conn, :edit, 1))
      assert response(conn, 404)
    end

  end

end
