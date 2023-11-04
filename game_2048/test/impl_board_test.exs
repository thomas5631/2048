defmodule Game2048ImplBoardTest do
  use ExUnit.Case
  alias Game2048.Impl.Board

  test "create returns an n*n board" do
    board = Board.create(4)
    assert length(board) == 4
    Enum.each(board, fn row -> assert length(row) == 4 end)
  end

  test "create raises when board is too small" do
    assert_raise RuntimeError, ~r/minimum board size is 2/i, fn ->
      Board.create(1)
    end
  end

  test "create raises when board is too large" do
    assert_raise RuntimeError, ~r/maximum board size is 7/i, fn ->
      Board.create(8)
    end
  end

  test "no_moves_remain returns true when no direction will affect the board" do
    board = [[2, 4], [8, 16]]
    assert Board.no_moves_remain?(board) == true
  end

  test "no_moves_remain returns false valid moves can still be made" do
    board = [[2, 2], [8, 16]]
    assert Board.no_moves_remain?(board) == false
  end

  test "has_empty_space returns true when there is an empty space" do
    board = [[2, 0], [8, 16]]
    assert Board.has_empty_space?(board) == true
  end

  test "has_empty_space returns false when there is no empty space" do
    board = [[2, 32], [8, 16]]
    assert Board.has_empty_space?(board) == false
  end

  test "maybe_place_new_tile adds a 2 tile to an incomplete board" do
    incomplete_board = [[2, 0], [8, 16]]
    new_board = [[2, 2], [8, 16]]
    assert Board.maybe_place_new_tile(incomplete_board, 2) == new_board
  end

  test "maybe_place_new_tile does not add a tile to a full board" do
    full_board = [[2, 2], [8, 16]]
    assert Board.maybe_place_new_tile(full_board, 2) == full_board
  end

  test "slide moves tiles all possible steps in direction specified" do
    [
      # direction | initial_board | after_move
      [:left, [[0, 0, 2], [0, 0, 2], [0, 0, 2]], [[2, 0, 0], [2, 0, 0], [2, 0, 0]]],
      [:right, [[2, 0, 0], [2, 0, 0], [2, 0, 0]], [[0, 0, 2], [0, 0, 2], [0, 0, 2]]],
      [:up, [[0, 0, 0], [0, 0, 0], [2, 2, 2]], [[2, 2, 2], [0, 0, 0], [0, 0, 0]]],
      [:down, [[2, 2, 2], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [2, 2, 2]]]
    ]
    |> Enum.each(&test_slide/1)
  end

  test "slide removes gaps between tiles in direction specified" do
    [
      # direction | initial_board | after_move
      [:left, [[16, 0, 2], [16, 0, 2], [16, 0, 2]], [[16, 2, 0], [16, 2, 0], [16, 2, 0]]],
      [:right, [[16, 0, 2], [16, 0, 2], [16, 0, 2]], [[0, 16, 2], [0, 16, 2], [0, 16, 2]]],
      [:up, [[16, 16, 16], [0, 0, 0], [2, 2, 2]], [[16, 16, 16], [2, 2, 2], [0, 0, 0]]],
      [:down, [[16, 16, 16], [0, 0, 0], [2, 2, 2]], [[0, 0, 0], [16, 16, 16], [2, 2, 2]]]
    ]
    |> Enum.each(&test_slide/1)
  end

  test "slide combines tiles in direction specified" do
    [
      # direction | initial_board | after_move
      [:left, [[2, 2], [2, 2]], [[4, 0], [4, 0]]],
      [:right, [[2, 2], [2, 2]], [[0, 4], [0, 4]]],
      [:up, [[2, 2], [2, 2]], [[4, 4], [0, 0]]],
      [:down, [[2, 2], [2, 2]], [[0, 0], [4, 4]]]
    ]
    |> Enum.each(&test_slide/1)
  end

  test "slide combines tiles starting with side specified" do
    [
      # direction | initial_board | after_move
      [:left, [[2, 2, 2], [2, 2, 2], [2, 2, 2]], [[4, 2, 0], [4, 2, 0], [4, 2, 0]]],
      [:right, [[2, 2, 2], [2, 2, 2], [2, 2, 2]], [[0, 2, 4], [0, 2, 4], [0, 2, 4]]],
      [:up, [[2, 2, 2], [2, 2, 2], [2, 2, 2]], [[4, 4, 4], [2, 2, 2], [0, 0, 0]]],
      [:down, [[2, 2, 2], [2, 2, 2], [2, 2, 2]], [[0, 0, 0], [2, 2, 2], [4, 4, 4]]]
    ]
    |> Enum.each(&test_slide/1)
  end

  test "calculate_score returns sum of all tiles" do
    board = [[2, 32], [8, 16]]
    assert Board.calculate_score(board) == 58
  end

  def test_slide([direction, initial_board, after_move]) do
    assert Board.slide(initial_board, direction) == after_move
  end
end
