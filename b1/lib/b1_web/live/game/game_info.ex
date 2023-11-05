defmodule B1Web.Live.Game.GameInfo do
  use B1Web, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <h2 class="text-xl"><%= @status.score %></h2>
      <h2 class="text-sm">Current score</h2>
    </div>
    """
  end
end
