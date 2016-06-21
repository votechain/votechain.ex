defmodule Votechain.VoteController do
	use Votechain.Web, :controller
    use Timex
	require Logger

   def new(conn, %{"vote" => vote}) do
    vote
    |> String.to_integer
    |> Votechain.Core.send_vote
    render(conn, "index.json", message: "hola mundo")
    end


    def index(conn, _params) do
        # Example of JSON vote response. Hardoded for testing
        voting = %{voting: %{
                    id: 10,
                    type: :Diputados,
                    vote_date: :dia,
                    voting_totals: [
                    %{
                        id: 234,
                        politic_party: :JUJIU,
                        total_votes: 200,
                        candidate_name: :Fabiola
                    },
                    %{
                        id: 43,
                        politic_party: :JUJIU,
                        total_votes: 200,
                        candidate_name: :Joaquin
                    }
                    ],
                    citizen_participation: 400,
                    total_votes: 123
            }
        }
        render(conn, "voting.json", voting: voting)
    end
end
