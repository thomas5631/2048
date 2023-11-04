defmodule Game2048.Runtime.Server do
  alias Game2048.Runtime.Watchdog
  alias Game2048.Impl.Game
  use GenServer, restart: :temporary

  @type t :: pid

  # 1 hour in ms
  @idle_timeout 1000 * 60 * 60

  ### client process
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  ### server process
  def init(size: size) do
    watcher = Watchdog.start(@idle_timeout)
    {:ok, {Game.new_game(size), watcher}}
  end

  def handle_call({:make_move, direction}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {updated_game, status} = Game.make_move(game, direction)
    {:reply, status, {updated_game, watcher}}
  end

  def handle_call({:status}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {:reply, Game.status(game), {game, watcher}}
  end
end
