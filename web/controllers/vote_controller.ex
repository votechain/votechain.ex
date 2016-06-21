defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"candidate" => candidate, "gender" => gender}) do
		candidate
		|> String.to_integer 
		|> Votechain.Core.send_vote(gender)
		render(conn, "index.json", message: "hola mundo")
	end

	def return_number(conn, _params) do
		number = Votechain.Core.get_number
		render(conn, "show.json", number: number)
	end

	def get_total_votes(conn, _params) do
		votes = Votechain.get_total_votes()
		render(conn, "show.json", votes: votes)
	end

	def get_votes(conn, %{"param" => param, "filter" => filter}) do
		votes = Votechain.get_total_votes(param, filter)
		render(conn, "show.json", votes: votes)
	end

end
