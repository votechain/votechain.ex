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

	def handle_call({:name, name}, _from, state) do
		{:ok, state} = hello(name)
		{:reply, state}
	end

	def send(name) do
		:poolboy.transaction(:core_action_votes,
			fn(pid) -> :gen_server.call(pid, {:name, name}) end)
	end

	defp hello(name) do
		python_path = "/Users/gustavo/Documents/votechain/votechain/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python'}])
		:python.call(pid, :hello_world, :hello, [name])
		:flush
		{:ok, "okas"}		
	end
	
end