defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"vote" => vote}) do
		vote
		|> String.to_integer 
		|> Votechain.Core.send_vote
		render(conn, "index.json", message: "hola mundo")
	end

	def return_number(conn, _params) do
		number = Votechain.Core.get_number
		render(conn, "show.json", number: number)
	end
end
