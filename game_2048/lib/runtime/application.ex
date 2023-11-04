defmodule Game2048.Runtime.Application do
  @super_name GameStarter

  use Application

  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @super_name}
    ]

    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_game(args) do
    DynamicSupervisor.start_child(@super_name, {Game2048.Runtime.Server, args})
  end
end
