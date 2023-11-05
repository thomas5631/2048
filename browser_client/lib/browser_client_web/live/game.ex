defmodule BrowserClientWeb.Live.Game do
  use BrowserClientWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket |> assign(%{setup_required: true})
    {:ok, socket}
  end

  def handle_event("restart_game", _, socket) do
    {:noreply, assign(socket, setup_required: true)}
  end

  def handle_event("new_game", %{"size" => size}, socket) do
    game = Game2048.new_game(String.to_integer(size))
    status = Game2048.status(game)

    socket = socket |> assign(%{game: game, status: status, setup_required: false})
    {:noreply, assign(socket, status: status)}
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
    <div id="game" phx-window-keyup="make_move">
      <%= if assigns.setup_required do %>
        <.live_component module={BrowserClientWeb.Live.Game.NewGame} id="new_game" />
      <% else %>
        <div class="flex flex-col space-y-4 relative p-4">
          <%= if assigns.status.game_state in [:won, :lost] do %>
            <div class="absolute flex flex-col justify-center items-center m-auto left-0 right-0 top-0 bottom-0 backdrop-blur-sm">
              <.live_component
                module={BrowserClientWeb.Live.Game.RestartMenu}
                status={assigns.status}
                id="restart_menu"
              />
            </div>
          <% end %>
          <.live_component
            module={BrowserClientWeb.Live.Game.GameScore}
            score={assigns.status.score}
            id="game_score"
          />
          <.live_component
            module={BrowserClientWeb.Live.Game.Board}
            status={assigns.status}
            id="game_board"
          />
          <.live_component
            module={BrowserClientWeb.Live.Game.Controls}
            status={assigns.status}
            id="game_controls"
          />
        </div>
      <% end %>
    </div>
    """
  end
end
