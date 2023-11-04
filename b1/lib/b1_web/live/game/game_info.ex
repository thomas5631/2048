defmodule B1Web.Live.Game.GameInfo do
  use B1Web, :live_component

  @states %{
    move_accepted: "Move accepted",
    move_invalid: "Move doesn't affect the game",
    lost: "Sorry, you lost.",
    won: "You won!",
    initializing: "Slide the tiles using the buttons or arrow keys"
  }

  @moves %{
    nil: "No move",
    left: "Left",
    right: "Right",
    up: "Up",
    down: "Down"
  }

  defp state_name(state) do
    @states[state] || "Unknown state"
  end

  defp move_name(move) do
    @moves[move] || "Unknown move"
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-between">
      <div>
        <%= state_name(@status.game_state) %>
      </div>
      <div>
        Current score: <%= @status.score %>
      </div>
      <div>
        Previous move: <%= move_name(@status.previous_move) %>
      </div>
    </div>
    """
  end
end
