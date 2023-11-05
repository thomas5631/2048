defmodule BrowserClientWeb.Live.Game.GameScore do
  use BrowserClientWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <div class="text-xl"><%= @score %></div>
      <div class="text-sm">Current score</div>
    </div>
    """
  end
end
