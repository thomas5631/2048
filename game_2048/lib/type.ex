defmodule Game2048.Type do
  @type state :: :initializing | :won | :lost | :move_accepted | :move_invalid

  @type direction :: :left | :right | :up | :down

  @type status :: %{
          game_state: state,
          previous_move: nil | direction,
          board: [list[Integer.t()]],
          score: Integer.t()
        }
end
