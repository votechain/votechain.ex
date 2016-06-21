defmodule Votechain.Core do
	use GenServer
	require Logger

	## Client API
	def start_link do
		GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
	end

	#def insert_vote do
		## Must run a python script to insert the vote
	#end

	def hello(name) do
		GenServer.call(__MODULE__, {:name, name})
	end

	## Server Callbacks

	def init(:ok) do
		Logger.info "Core server started"
		{:ok, %{}}
	end

	def handle_call({:name, name}, _from, state) do
		{:ok, value, state} = hello(name)
	end

	def hello(name) do
		python_path = "/Users/gustavo/Documents/votechain/votechain/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python'}])
		:python.call(pid, :hello_world, :hello, [])
		:flush		
	end
	
end