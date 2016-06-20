ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Votechain.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Votechain.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Votechain.Repo)

