defmodule BrowserClientWeb.Live.Game.Board do
  use BrowserClientWeb, :live_component

  defp tile_id(idc, idr) do
    [
      "tile",
      Integer.to_string(idc),
      Integer.to_string(idr)
    ]
  end

  def render(assigns) do
    ~H"""
    <div id="board" class="flex flex-col items-center" phx-hook="swipeable_hook">
      <%= for {row, idr} <- Enum.with_index(@status.board) do %>
        <div class="flex flex-row justify-center bg-gray-200">
          <%= for {value, idc} <- Enum.with_index(row) do %>
            <.live_component
              module={BrowserClientWeb.Live.Game.Tile}
              value={value}
              id={tile_id(idc, idr)}
            />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
