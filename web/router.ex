defmodule Formerer.Router do
  use Formerer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate_user do
    plug Formerer.UserAuthentication
  end

  pipeline :activated_account do
    plug Formerer.AccountActivation
  end

  scope "/form", Formerer do
    pipe_through :api

    post "/:slug", FormSubmissionsController, :create
  end

  scope "/", Formerer do
    pipe_through [:browser, :protect_from_forgery]

    get "/", PageController, :index

    get "/register", UsersController, :new
    post "/register", UsersController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    resources "account_activation", AccountActivationController, only: [:edit]

    pipe_through :authenticate_user
    get "/dashboard", DashboardController, :index
    pipe_through :activated_account
    resources "users", UsersController, only: [:edit, :update]

    resources "forms", FormsController, only: [:new, :create, :update, :show] do
      get "columns/edit", FormColumnsController, :edit
      post "columns/update", FormColumnsController, :update
    end
  end

  if Mix.env == :dev do
      scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end

end
