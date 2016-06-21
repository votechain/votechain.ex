defmodule Votechain do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config_item_action = [
      {:name, {:local, :core_action}},
      {:worker_module, Votechain.Core},
      {:size, 5},
      {:max_overflow, 1}
    ]

    children = [
      # Start the endpoint when the application starts
      supervisor(Votechain.Endpoint, []),
      # Start the Ecto repository
      supervisor(Votechain.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Votechain.Worker, [arg1, arg2, arg3]),

      #Poolboy definition
      :poolboy.child_spec(:core_action, poolboy_config_item_action, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Votechain.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Votechain.Endpoint.config_change(changed, removed)
    :ok
  end
end
