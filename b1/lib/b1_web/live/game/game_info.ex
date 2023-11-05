defmodule B1Web.Live.Game.GameInfo do
  use B1Web, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-around">
      <div>
        Current score: <%= @status.score %>
      </div>
    </div>
    """
  end
end
