defmodule BrowserClientWeb.Live.Game.Tile do
  use BrowserClientWeb, :live_component

  @tile_classes %{
    1 => "bg-gray-100 text-gray-700",
    2 => "bg-yellow-100 text-yellow-700",
    4 => "bg-orange-100 text-orange-700",
    8 => "bg-teal-100 text-teal-700",
    16 => "bg-blue-100 text-blue-700",
    32 => "bg-indigo-100 text-indigo-700",
    64 => "bg-purple-100 text-purple-700",
    128 => "bg-pink-100 text-pink-700",
    256 => "bg-red-100 text-red-700",
    512 => "bg-yellow-600 text-yellow-100",
    1024 => "bg-green-600 text-green-100",
    2048 => "bg-green-100 text-green-700"
  }

  defp class_for_value(value) do
    [
      "w-12 h-12 flex justify-center items-center px-4 py-2 m-1 rounded",
      @tile_classes[value] || "text-gray-700 bg-gray-400"
    ]
  end

  defp display_value(0), do: ""
  defp display_value(value), do: value

  def render(assigns) do
    ~H"""
    <div class={class_for_value(@value)}><%= display_value(@value) %></div>
    """
  end
end
