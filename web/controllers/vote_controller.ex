defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, %{"name" => name}) do
		##Votechain.Core.send(name)
		render(conn, "index.json", message: "hola mundo")
	end
end
