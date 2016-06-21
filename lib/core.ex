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

	def handle_call({:name, name}, _from, _state) do
		Logger.info "handle_call"
		{:ok, state} = hello(name)
		{:reply, :ok, state}
	end

	def handle_call({:vote, vote}, _from, _state) do
		Logger.info "make a vote"
		{:ok, state} = create_vote(vote)
		{:reply, :ok, state}
	end

	## Function that return the toal number of votes
	def handle_call({:total_votes, \\param}, _from, _state) do
		Logger.info "total votes"
		{:ok, state} = get_total_votes_py(param)
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

	def send_vote(vote) do
		Logger.info "send vote"
		:poolboy.transaction(:core_action, 
			fn(pid) -> :gen_server.call(pid, {:vote, vote})
		end)
	end

	def get_total_votes(param) do
		:poolboy.transaction(:core_action, 
			fn(pid) -> :gen_server.call(pid, {:total_votes, param})
		end)
	end

	def get_number() do
		Logger.info "get number"
		:poolboy.transaction(:core_action, 
			fn(pid) -> :gen_server.call(pid, {:number})
		end)
	end

	defp get_number_py() do
		python_path = "/Users/gustavo/Documents/votechain/votechain/priv/python"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		result = :python.call(pid, :return_number, :return_number, [])	
		Logger.info "lala #{inspect result}"
		{:ok, result}
	end

	defp create_vote(vote) do
		python_path = "/home/chemonky/votechain/votechain.ex/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		:python.call(pid, :insert_vote, :insert_vote, [vote])
		:flush
		{:ok, vote}
	end

	defp hello(name) do
		python_path = "/home/chemonky/votechain/votechain.ex/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		:python.call(pid, :hello_world, :hello, [name])
		:flush
		{:ok, name}
	end

	defp get_total_votes_py(param) do
		python_path = "/home/chemonky/votechain/votechain.ex/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		total_votes = :python.call(pid, :hello_world, :hello, [name])
		{:ok, total_votes}
	end

end
