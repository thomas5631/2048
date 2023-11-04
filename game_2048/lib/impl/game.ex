defmodule Game2048.Impl.Game do
  @winning_value 2048
  @new_tile_value 1

  alias Game2048.Type
  alias Game2048.Impl.Board

  @type t :: %Game2048.Impl.Game{
          game_state: Type.state(),
          previous_move: nil | Type.direction(),
          board: Board.t()
        }

  defstruct(
    game_state: :initializing,
    previous_move: nil,
    board: [[]]
  )

  @spec new_game(Integer.t()) :: t

  def new_game(size) do
    board = Board.create(size)

    initial_board =
      board
      |> Board.maybe_place_new_tile(@new_tile_value)

    %__MODULE__{
      board: initial_board
    }
  end

  @spec make_move(t, Type.direction()) :: {t, Type.status()}

  def make_move(game = %{game_state: game_state}, _) when game_state in [:won, :lost] do
    {game, status(game)}
  end

  def make_move(game = %{board: board}, direction) do
    updated_board = Board.slide(board, direction)
    accept_move(%{game | board: updated_board, previous_move: direction}, updated_board != board)
  end

  @spec status(t) :: Type.status()

  def status(game) do
    %{
      game_state: game.game_state,
      previous_move: game.previous_move,
      board: game.board,
      score: Board.calculate_score(game.board)
    }
  end

  @spec accept_move(t, boolean) :: {t, Type.status()}

  defp accept_move(game, _board_changed = false) do
    %{game | game_state: :move_invalid}
    |> return_with_status
  end

  defp accept_move(game, _board_changed = true) do
    update_game(game, meets_win_condition?(game))
    |> return_with_status
  end

  @spec meets_win_condition?(t) :: boolean

  defp meets_win_condition?(game) do
    game.board |> List.flatten() |> Enum.any?(&(&1 == @winning_value))
  end

  @spec return_with_status(t) :: {t, Type.status()}

  defp return_with_status(game) do
    {game, status(game)}
  end

  @spec update_game(t, boolean) :: t

  defp update_game(game, _meets_win_condition = true) do
    %{game | game_state: :won}
  end

  defp update_game(game, _meets_win_condition) do
    updated_board = Board.maybe_place_new_tile(game.board, @new_tile_value)

    %{
      game
      | board: updated_board,
        game_state: maybe_lost(Board.no_moves_remain?(updated_board))
    }
  end

  @spec maybe_lost(boolean) :: :lost | :move_accepted

  defp maybe_lost(true), do: :lost

  defp maybe_lost(_), do: :move_accepted
end
