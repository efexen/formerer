defmodule Formerer.UserTest do
  use Formerer.ModelCase
  alias Formerer.User
  import Formerer.UserFactory
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @valid_attrs %{email: "test@email.com", password: "somecontent"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_change_changeset with valid attributes" do
    user = insert(:user, [password_digest: hashpwsalt("ins3cure")])
    changeset = User.password_change_changeset(user, %{old_password: "ins3cure", password: "newpassword", confirm_password: "newpassword"})
    assert changeset.valid?
  end

  test "password_change_changeset with invalid old password" do
    user = insert(:user, [password_digest: hashpwsalt("ins3cure")])
    changeset = User.password_change_changeset(user, %{old_password: "too3cure", password: "newpassword", confirm_password: "newpassword"})
    refute changeset.valid?
  end

  test "password_change_changeset with new password confirmation not matching" do
    user = insert(:user, [password_digest: hashpwsalt("ins3cure")])
    changeset = User.password_change_changeset(user, %{old_password: "ins3cure", password: "newpassword", confirm_password: "otherpassword"})
    refute changeset.valid?
  end

  test "token_changeset with valid attributes" do
    user = insert(:user, [token: "usertoken"])
    changeset = User.token_changeset(user, %{token: "usertoken"})
    assert changeset.valid?
  end

  test "token_changeset with wrong token" do
    user = insert(:user, [token: "usertoken"])
    changeset = User.token_changeset(user, %{token: "wrongtoken"})
    refute changeset.valid?
  end
end
