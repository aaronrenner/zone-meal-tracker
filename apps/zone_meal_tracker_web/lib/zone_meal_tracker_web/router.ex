defmodule ZoneMealTrackerWeb.Router do
  use ZoneMealTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication_required do
    plug ZoneMealTrackerWeb.Plugs.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZoneMealTrackerWeb do
    pipe_through [:browser, :authentication_required]

    get "/", PageController, :index
  end

  scope "/", ZoneMealTrackerWeb do
    pipe_through :browser

    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
    resources "/users", UserController, only: [:new, :create]
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", ZoneMealTrackerWeb do
  #   pipe_through :api
  # end
end
