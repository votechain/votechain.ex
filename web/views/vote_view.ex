defmodule Votechain.VoteView do
	use Votechain.Web, :view

	def render("index.json", %{message: message}) do
		%{message: message}
	end

	def render("show.json", %{number: number}) do
		%{data: number}
	end
end