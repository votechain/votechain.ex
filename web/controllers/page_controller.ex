defmodule Votechain.PageController do
  use Votechain.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
