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
		{:reply, state}
	end

	def send(name) do
		Logger.info "send"
		:poolboy.transaction(:core_action,
			fn(pid) -> :gen_server.call(pid, {:name, name})
		end)
	end

	defp hello(name) do
		python_path = "/home/chemonky/votechain/votechain.ex/priv/python_scripts"
		{:ok, pid} = :python.start_link([{:python_path, to_char_list(python_path)}, {:python, 'python3'}])
		:python.call(pid, :hello_world, :hello, [name])
		:flush
		{:ok, :ok}
	end

end
