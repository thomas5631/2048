defmodule BrowserClientWeb.Live.Game.NewGame do
  use BrowserClientWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-4">
      <%= for size <- [2, 3, 4, 5, 6, 7] do %>
        <button
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          phx-click="new_game"
          phx-value-size={Integer.to_string(size)}
        >
          <%= size %> x <%= size %>
        </button>
      <% end %>
    </div>
    """
  end
end
