defmodule Votechain.Core do
	use GenServer
	require Logger

	## Client API

	def start_link([]) do
		GenServer.start_link(__MODULE__, [], [])
	end

	def say_hello(name) do
		GenServer.call(__MODULE__, {:name, name})
	end

	## Server Callbacks

	def init(_opts) do
		Logger.info "Core server started"
		{:ok, %{}}
	end

	def handle_cast({:name, name}, _state) do
		Logger.info "handle_call"
		{:ok, state} = hello(name)
		{:noreply, state}
	end

	def handle_call({:vote, vote}, _from, _state) do
		Logger.info "make a vote"
		{:ok, state} = create_vote(vote)
		{:reply, :ok, state}
	end

	## Function that return the toal number of votes
	def handle_call({:get_total_votes}, _from, _state) do
		{:ok, state} = get_total_votes_py()
		{:reply, state, state}
	end

	def handle_call({:filter, filter, :param, param}) do
		{:ok,	state} = get_votes_by(param, filter)
		{:reply, state, state}
	end

	def handle_call({:number}, _from, _state) do
		Logger.info "get number in process"
		{:ok, state} = get_number_py()
		{:reply, state, state}
	end

	def send(name) do
		Logger.info "send"
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.call(pid, {:name, name})
		end)
	end

	def send_vote(candidate, gender) do
		Logger.info "send vote"
		vote = %{
			:candidate => candidate,
			:gender => gender
		}
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.cast(pid, {:vote, vote})
		end)
	end

	def get_total_votes() do
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.call(pid, {:get_total_votes})
		end)
	end

	def get_total_votes(param, filter) do
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.call(pid, {:filter, filter, :param, param})
		end)
	end

	def get_number() do
		Logger.info "get number"
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.call(pid, {:number})
		end)
	end

	defp get_number_py() do
		python_path = "/home/amet/votechain.ex/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		result = :python.call(pid, :return_number, :return_number, [])
		Logger.info "lala #{inspect result}"
		{:ok, result}
	end

	defp create_vote(vote) do
		python_path = "/home/amet/votechain.ex/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		:python.call(pid, :insert_vote, :insert_vote, [vote.candidate, vote.gender])
		:flush
		:python.stop(pid)
		{:ok, vote}
	end

	defp hello(name) do
		python_path = "/home/amet/votechain.ex/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		:python.call(pid, :hello_world, :hello, [name])
		:flush
		{:ok, name}
	end

	defp get_total_votes_py() do
		python_path = "/home/amet/votechain.ex/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		total_votes = :python.call(pid, :get_votes, :get_total_votes, [])
		{:ok, total_votes}
	end

	def get_votes_by(param, filter) do
		python_path = "/home/amet/votechain.ex/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])

		case filter do
			"district" ->
				total_votes = :python.call(pid, :get_votes, :get_votes_by, [param, filter])
				{:ok, total_votes}
			"state" ->
				state = String.to_integer(param)
				total_votes = :python.call(pid, :get_votes, :get_votes_by, [param, filter])
				{:ok, total_votes}
			"gender" ->
				total_votes = :python.call(pid, :get_votes, :get_votes_by, [param, filter])
				{:ok, total_votes}
			"candidate" ->
				candidate = String.to_integer(param)
				total_votes = :python.call(pid, :get_votes, :get_votes_by, [param])
				{:ok, total_votes}
		end
	end

end
