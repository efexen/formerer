defmodule Formerer.AccountActivationControllerTest do
  use Formerer.ConnCase
  import Formerer.UserFactory

  setup %{conn: conn} = config do
    user = insert(:user, activated: false, token: "activationtoken")
    {:ok, conn: conn, user: user}
  end

  test "user can activate account with correct token", %{conn: conn, user: user} do
    conn = get(conn, account_activation_path(conn, :edit, "activationtoken"))

    assert html_response(conn, 302)
    updated_user = Repo.get(Formerer.User, user.id)

    assert updated_user.activated == true
    assert updated_user.token == nil
  end

end
