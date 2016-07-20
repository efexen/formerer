defmodule Formerer.PasswordResetControllerTest do
  use Formerer.ConnCase
  import Formerer.UserFactory
  import Swoosh.TestAssertions
  import Comeonin.Bcrypt, only: [checkpw: 2, hashpwsalt: 1]

  setup %{conn: conn} = config do
    if %{email: email, password: password, token: token} = config do
      user = insert(:user, [email: email, password_digest: hashpwsalt(password), token: token])
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag email: "test@example.com", password: "ins3cure", token: nil
  test "user with correct email initiate password reset", %{conn: conn, user: user} do
    conn = post(conn, password_reset_path(conn, :create), user: %{email: "test@example.com"})

    assert html_response(conn, 302)
    updated_user = Repo.get(Formerer.User, user.id)
    assert String.length(updated_user.token) == 64

    assert_email_sent subject: "Formerer password reset request"
  end

  @tag email: "test@example.com", password: "ins3cure", token: nil
  test "user with correct email cannot initiate password reset", %{conn: conn, user: user} do
    conn = post(conn, password_reset_path(conn, :create), user: %{email: "wrong@example.com"})

    assert html_response(conn, 200) =~ "Incorrect email address"
  end

  @tag email: "test@example.com", password: "ins3cure", token: "t0k3n"
  test "user can access password reset page with correct token", %{conn: conn} do
    conn = get(conn, password_reset_path(conn, :edit, "t0k3n"))

    assert html_response(conn, 200)
  end

  @tag email: "test@example.com", password: "ins3cure", token: "t0k3n"
  test "user cannot access password reset page with incorrect token", %{conn: conn} do
    conn = get(conn, password_reset_path(conn, :edit, "incorrect"))

    assert html_response(conn, 302)
  end

  @tag email: "test@example.com", password: "ins3cure", token: "t0k3n"
  test "user can reset password with correct token", %{conn: conn, user: user} do
    conn = put(conn, password_reset_path(conn, :update, "t0k3n"), user: %{token: "t0k3n", password: "toos3cure", confirm_password: "toos3cure"})

    assert html_response(conn, 302)
    updated_user = Repo.get(Formerer.User, user.id)

    assert updated_user.token == nil
    assert checkpw("toos3cure", updated_user.password_digest)
  end

  @tag email: "test@example.com", password: "ins3cure", token: "t0k3n"
  test "user cannot reset password with incorrect token", %{conn: conn, user: user} do
    conn = put(conn, password_reset_path(conn, :update, "incorrect-token"), user: %{token: "incorrect-token", password: "toos3cure", confirm_password: "toos3cure"})

    assert html_response(conn, 200) =~ "Password reset error"
    updated_user = Repo.get(Formerer.User, user.id)

    assert updated_user.token == "t0k3n"
    assert checkpw("ins3cure", updated_user.password_digest)
  end

end
