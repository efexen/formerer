defmodule Formerer.Feature.RegistrationTest do
  import String, only: [contains?: 2]
  import Formerer.UserFactory, only: [insert: 1]

  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "user can register" do
    navigate_to("/")
    find_element(:link_text, "Register") |> click

    fill_field(email_field, "formerer@email.com")
    fill_field(password_field, "password123")
    click(register_button)

    nav_text = find_element(:css, ".mdl-navigation") |> visible_text
    assert contains?(nav_text, "formerer@email.com")
    assert contains?(nav_text, "Logout")
  end

  test "already taken email address shows error to user" do
    user = insert(:user)

    navigate_to("/register")
    fill_field(email_field, user.email)
    fill_field(password_field, "password123")
    click(register_button)

    alerts = find_element(:css, ".alert")
    assert contains?(visible_text(alerts), "already been taken")
  end

  defp register_button do
    find_element(:css, "input[type=submit]")
  end

  defp email_field do
    find_element(:id, "user_email")
  end

  defp password_field do
    find_element(:id, "user_password")
  end

end
