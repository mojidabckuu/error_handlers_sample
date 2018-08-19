defmodule ErrorHandlerWeb.Router do
  use ErrorHandlerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ErrorHandlerWeb do
    pipe_through :api
  end
end
