defmodule ZoneMealTrackerWeb.Router do
  use ZoneMealTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZoneMealTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
    resources "/users", UserController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ZoneMealTrackerWeb do
  #   pipe_through :api
  # end
end
