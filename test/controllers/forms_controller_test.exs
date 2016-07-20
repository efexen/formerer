defmodule Formerer.FormsControllerTest do
  use Formerer.ConnCase
  alias Formerer.{UserFactory, FormFactory}

  setup %{conn: conn} = config do
    if %{activated: activated} = config do
      user = UserFactory.insert(:user, [activated: activated])
      login_custom_user(conn, user)
    else
      :ok
    end
  end

  @tag activated: false
  test "non activated user cannot create forms", %{conn: conn, user: user} do
    conn = get(conn, forms_path(conn, :new))

    assert html_response(conn, 302)
    assert conn.halted
  end

  @tag activated: true
  test "activated user can create forms", %{conn: conn, user: user} do
    conn = get(conn, forms_path(conn, :new))

    assert html_response(conn, 200)
  end

  describe "DELETE #destroy" do

    setup %{ conn: conn, user: user } do
      form = FormFactory.insert(:form, user: user)
      { :ok, conn: conn, user: user, form: form }
    end

    @tag activated: true
    test "user can delete their own form", %{ conn: conn, user: user, form: form } do
      delete(conn, forms_path(conn, :delete, form))

      assert Repo.get(Formerer.Form, form.id) == nil
    end

    @tag activated: true
    test "deleting form successfully redirects to dashboard", %{ conn: conn, user: user, form: form } do
      conn = delete(conn, forms_path(conn, :delete, form))

      assert redirected_to(conn) =~ dashboard_path(conn, :index)
    end

    @tag activated: true
    test "user can not delete someone elses form", %{ conn: conn, user: user, form: form } do
      other_form = FormFactory.insert(:form)

      conn = delete(conn, forms_path(conn, :delete, other_form))
      assert response(conn, 404)
    end

  end

  # add some more test for user not being able to access other user forms

end
