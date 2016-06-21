defmodule Votechain.VoteController do
	use Votechain.Web, :controller
	require Logger

	def new(conn, _params) do
		Logger.info "Vototototototo"
		python_path = "/Users/gustavo/Documents/votechain/votechain/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python'}])
		Logger.info "pid #{inspect pid}"
		:python.call(pid, :hello_world, :hello, [])
		:flush

		render(conn, "index.json", message: "hola mundo")
	end
end