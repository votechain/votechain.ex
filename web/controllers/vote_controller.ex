defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"vote" => vote}) do
		vote
		|> String.to_integer 
		|> Votechain.Core.send_vote
		render(conn, "index.json", message: "hola mundo")
	end
end
