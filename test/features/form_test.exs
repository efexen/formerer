defmodule Formerer.Feature.FormTest do
  import String, only: [contains?: 2]
  alias Formerer.{UserFactory, FormFactory}

  use ExUnit.Case
  use Hound.Helpers

  hound_session

  setup_all do
    {:ok, user: UserFactory.insert(:user)}
  end

  test "user can create a new form", test_data do
    form_name = "Super Testy Form oooh"
    login(test_data[:user].email, "ins3cure")

    find_element(:css, ".mdl-layout__drawer-button i") |> click
    find_element(:css, ".new-form-link") |> click

    find_element(:id, "form_name") |> fill_field(form_name)
    find_element(:css, "form .mdl-button") |> click

    assert contains?(visible_page_text, "Form Created")
    assert contains?(visible_page_text, form_name)
  end

  test "user can navigate to form and view the endpoint url", test_data do
    form = FormFactory.insert(:form, [user: test_data[:user]])
    login(test_data[:user].email, "ins3cure")

    find_element(:css, ".mdl-layout__drawer-button i") |> click
    find_element(:partial_link_text, form.name) |> click

    assert contains?(visible_page_text, form.name)

    endpoint_url = find_element(:id, "form-endpoint-url") |> attribute_value(:value)
    assert contains?(endpoint_url, "/form/#{form.identifier}")
  end

  test "user can rename the form", test_data do
    form = FormFactory.insert(:form, [user: test_data[:user]])
    login(test_data[:user].email, "ins3cure")
    navigate_to("/forms/#{form.id}")

    find_element(:css, "[data-behaviour=\"edit-form-name\"]") |> click
    send_keys(:backspace)
    send_text("Wow Such Form")
    send_keys(:enter)

    refresh_page
    assert contains?(visible_page_text, "Wow Such Form")
  end

  defp login(username, password) do
    navigate_to("/login")
    find_element(:id, "session_email") |> fill_field(username)
    find_element(:id, "session_password") |> fill_field(password)
    find_element(:css, "form .mdl-button") |> click
  end

end
