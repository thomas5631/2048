defmodule BrowserClientWeb.Live.Game.RestartMenu do
  use BrowserClientWeb, :live_component

  @messages %{
    lost: "You lose!",
    won: "You win!",
    default: "Game over"
  }

  @classes %{
    lost: "bg-yellow-100",
    won: "bg-green-100",
    default: "bg-white"
  }

  def message_for_state(game_state) do
    @messages[game_state] || @messages.default
  end

  def class_for_state(game_state) do
    [
      "flex flex-col items-center border text-black px-4 py-3 rounded",
      @classes[game_state] || @classes.default
    ]
  end

  def render(assigns) do
    ~H"""
    <div class={class_for_state(@status.game_state)} role="alert">
      <strong class="font-bold text-xl"><%= message_for_state(@status.game_state) %></strong>
      <div class="pb-2">Final score: <%= assigns.status.score %></div>
      <button
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        phx-click="restart_game"
      >
        Try again?
      </button>
    </div>
    """
  end
end
