defmodule Formerer.Feature.LoginTest do
  import String, only: [contains?: 2]
  import Formerer.UserFactory

  use ExUnit.Case
  use Hound.Helpers

  hound_session

  setup_all do
    {:ok, user: insert(:user)}
  end

  test "existing user can login", test_data do
    login(test_data[:user].email, "ins3cure")
    assert contains?(visible_page_text, "Welcome back")
  end

  test "existing user with wrong password sees error", test_data do
    login(test_data[:user].email, "wrong")
    assert contains?(visible_page_text, "Wrong email or password")
  end

  test "non existing user cant login" do
    login("nonuser@email.com", "wrong")
    assert contains?(visible_page_text, "Wrong email or password")
  end

  test "user can logout", test_data do
    login(test_data[:user].email, "ins3cure")
    find_element(:link_text, "Logout") |> click
    assert contains?(visible_page_text, "Logged out")
  end


  defp login(username, password) do
    navigate_to("/login")
    find_element(:id, "session_email") |> fill_field(username)
    find_element(:id, "session_password") |> fill_field(password)
    find_element(:css, "form .mdl-button") |> click
  end

end
