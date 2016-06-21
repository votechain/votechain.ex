defmodule Votechain.VoteView do
	use Votechain.Web, :view

	def render("index.json", %{message: message}) do
		%{message: message}
	end

	def render("show.json", %{votes: votes}) do
		%{data: votes}
	end

	def render("error.json", %{message: message}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: message}
  end
end