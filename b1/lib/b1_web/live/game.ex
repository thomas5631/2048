defmodule B1Web.Live.Game do
  use B1Web, :live_view

  def mount(_params, _session, socket) do
    game = Game2048.new_game(5)
    status = Game2048.status(game)

    socket = socket |> assign(%{game: game, status: status})
    {:ok, socket}
  end

  def handle_event("make_move", %{"key" => key}, socket)
      when key in ["ArrowLeft", "ArrowRight", "ArrowDown", "ArrowUp"] do
    keymap = %{
      "ArrowLeft" => :left,
      "ArrowRight" => :right,
      "ArrowUp" => :up,
      "ArrowDown" => :down
    }

    status = Game2048.make_move(socket.assigns.game, keymap[key])
    {:noreply, assign(socket, status: status)}
  end

  def handle_event("make_move", _args, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="make_move">
      <.live_component module={__MODULE__.GameInfo} status={assigns.status} id="game_info" />
      <.live_component module={__MODULE__.Board} status={assigns.status} id="board" />
      <.live_component module={__MODULE__.Controls} status={assigns.status} id="controls" />
    </div>
    """
  end
end
