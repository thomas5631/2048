defmodule Game2048 do
  alias Game2048.Runtime.Application
  alias Game2048.Runtime.Server
  alias Game2048.Type

  @opaque game :: Server.t()

  @spec new_game() :: game
  @spec new_game(Integer.t()) :: game
  def new_game(size \\ 4) do
    {:ok, pid} = Application.start_game(size: size)
    pid
  end

  @spec make_move(game, Type.direction()) :: Type.status()
  def make_move(game, direction) do
    GenServer.call(game, {:make_move, direction})
  end

  @spec status(game) :: Type.status()
  def status(game) do
    GenServer.call(game, {:status})
  end
end
