defmodule B1Web.Live.Game.Controls do
  use B1Web, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <button
        id="left-button"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
        phx-click="make_move"
        phx-value-key="ArrowLeft"
      >
        <.icon name="hero-arrow-left-solid" />
      </button>
      <button
        id="up-button"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
        phx-click="make_move"
        phx-value-key="ArrowUp"
      >
        <.icon name="hero-arrow-up-solid" />
      </button>
      <button
        id="down-button"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
        phx-click="make_move"
        phx-value-key="ArrowDown"
      >
        <.icon name="hero-arrow-down-solid" />
      </button>
      <button
        id="right-button"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
        phx-click="make_move"
        phx-value-key="ArrowRight"
      >
        <.icon name="hero-arrow-right-solid" />
      </button>
    </div>
    """
  end
end
