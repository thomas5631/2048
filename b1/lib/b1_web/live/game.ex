defmodule B1Web.Live.Game do
  use B1Web, :live_view

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
    <div>
      <%= if assigns.setup_required do %>
        <div class="flex flex-col items-center space-y-4">
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="2"
          >
            2 x 2
          </button>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="3"
          >
            3 x 3
          </button>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="4"
          >
            4 x 4
          </button>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="5"
          >
            5 x 5
          </button>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="6"
          >
            6 x 6
          </button>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-click="new_game"
            phx-value-size="7"
          >
            7 x 7
          </button>
        </div>
      <% else %>
        <div phx-window-keyup="make_move" class="flex flex-col space-y-4 relative p-4">
          <%= if assigns.status.game_state == :lost do %>
            <div class="absolute flex flex-col justify-center items-center m-auto left-0 right-0 top-0 bottom-0 backdrop-blur-sm">
              <div
                class="flex flex-col items-center bg-yellow-100 border text-black px-4 py-3 rounded"
                role="alert"
              >
                <strong class="font-bold text-xl">You lose!</strong>
                <div class="pb-2">Final score: <%= assigns.status.score %></div>
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                  phx-click="restart_game"
                >
                  Try again?
                </button>
              </div>
            </div>
          <% end %>
          <%= if assigns.status.game_state == :won do %>
            <div class="absolute flex flex-col justify-center items-center m-auto left-0 right-0 top-0 bottom-0 backdrop-blur-sm">
              <div
                class="flex flex-col items-center bg-green-100 border text-black px-4 py-3 rounded"
                role="alert"
              >
                <strong class="font-bold text-xl">You win!</strong>
                <div class="pb-2">Final score: <%= assigns.status.score %></div>
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                  phx-click="restart_game"
                >
                  Try again?
                </button>
              </div>
            </div>
          <% end %>
          <.live_component module={__MODULE__.GameInfo} status={assigns.status} id="game_info" />
          <.live_component module={__MODULE__.Board} status={assigns.status} id="game_board" />
          <.live_component module={__MODULE__.Controls} status={assigns.status} id="game_controls" />
        </div>
      <% end %>
    </div>
    """
  end
end
