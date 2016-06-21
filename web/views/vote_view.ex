defmodule Votechain.VoteView do
	use Votechain.Web, :view

	def render("index.json", %{message: message}) do
		%{message: message}
	end

	def render("show.json", %{votes: votes}) do
		%{data: votes}
	end
end