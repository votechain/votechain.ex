defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"candidate" => candidate, "gender" => gender}) do
		case String.valid?(candidate) do
			true ->
				candidate
				|> String.to_integer 
				|> Votechain.Core.send_vote(gender)
				render(conn, "index.json", message: "hola mundo")	
			false ->
				conn 
				|> put_status(400)
				|> render("error.json", message: %{code: "BAD REQUEST", message: "The candidate muts be an string"})
		end
		
	end

	def return_number(conn, _params) do
		number = Votechain.Core.get_number
		render(conn, "show.json", number: number)
	end

	def get_total_votes(conn, _params) do
		{_, result} = 
			Votechain.Core.get_total_votes()
			|> JSON.decode()
		render(conn, "show.json", votes: result)
	end

	def get_votes(conn, %{"param" => param, "filter" => filter}) do
		votes = Votechain.Core.get_total_votes(param, filter)
		render(conn, "show.json", votes: votes)
	end

end
