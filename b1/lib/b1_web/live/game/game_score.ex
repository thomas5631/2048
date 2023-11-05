defmodule B1Web.Live.Game.GameScore do
  use B1Web, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <div class="text-xl"><%= @score %></div>
      <div class="text-sm">Current score</div>
    </div>
    """
  end
end
