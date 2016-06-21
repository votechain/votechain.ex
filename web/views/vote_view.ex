defmodule Votechain.VoteView do
	use Votechain.Web, :view

	def render("index.json", %{message: message}) do
		%{message: message}
	end

    def render("voting.json", %{voting: voting}) do
       voting
    end
end