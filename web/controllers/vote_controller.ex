defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"name" => name}) do
		Logger.info "New"
		Votechain.Core.send_vote(name)
		render(conn, "index.json", message: "hola mundo")
	end
end
