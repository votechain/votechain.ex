defmodule Votechain.Router do
  use Votechain.Web, :router

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

  scope "/", Votechain do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/0.1", Votechain do
    pipe_through :api

    post "/votes", VoteController, :new
    get  "/number", VoteController, :return_number
    get "/votes", VoteController, :get_total_votes
    get "/votes/:filter/:param", VoteController, :get_votes
  end
end
