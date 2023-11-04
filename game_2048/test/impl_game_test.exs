defmodule Game2048ImplGameTest do
  use ExUnit.Case
  alias Game2048.Impl.Game

  test "new_game creates a new game of the provided size" do
    game = Game.new_game(4)
    assert game.previous_move == nil
    assert game.game_state == :initializing
    assert length(game.board) == 4
  end

  test "new_game creates a game with a single tile" do
    game = Game.new_game(4)
    assert game.previous_move == nil
    assert game.game_state == :initializing
    assert number_of_tiles_with_value(game.board, 1) == 1
  end

  test "make_move has no effect when game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game(4)
      game = Map.put(game, :game_state, state)
      {new_game, _status} = Game.make_move(game, :left)
      assert new_game == game
    end
  end

  test "make_move updates the game_state appropriately when a move has no effect on the board" do
    board = [[2, 16], [0, 0]]
    game = Game.new_game(2)
    game = Map.put(game, :board, board)
    {new_game, _status} = Game.make_move(game, :left)
    assert new_game.game_state == :move_invalid
    assert new_game.previous_move == :left
  end

  test "make_move adds a single tile with value 1 when a move is accepted" do
    board = [[2, 16], [0, 2]]
    game = Game.new_game(2)
    game = Map.put(game, :board, board)
    {new_game, _status} = Game.make_move(game, :down)
    assert new_game.game_state == :move_accepted
    assert new_game.previous_move == :down
    assert number_of_tiles_with_value(new_game.board, 1) == 1
  end

  test "make_move sets game_state to move_accepted when a move updates the state of the board and valid moves remain" do
    board = [[2, 16], [0, 2]]
    game = Game.new_game(2)
    game = Map.put(game, :board, board)
    {new_game, _status} = Game.make_move(game, :down)
    assert new_game.game_state == :move_accepted
    assert new_game.previous_move == :down
  end

  test "make_move sets game_state to lost when a move updates the state of the board and no valid moves remain" do
    board = [[8, 16], [32, 0]]
    game = Game.new_game(2)
    game = Map.put(game, :board, board)
    {new_game, _status} = Game.make_move(game, :down)
    assert new_game.game_state == :lost
    assert new_game.previous_move == :down
  end

  test "make_move sets game_state to won when a move produces a 2048" do
    board = [[1024, 16], [1024, 0]]
    game = Game.new_game(2)
    game = Map.put(game, :board, board)
    {new_game, _status} = Game.make_move(game, :down)
    assert new_game.game_state == :won
    assert new_game.previous_move == :down
  end

  test "status gives the external representation of the game" do
    game = Game.new_game(2)
    status = Game.status(game)

    assert status.previous_move == game.previous_move
    assert status.game_state == game.game_state
    assert status.score == 1
    assert status.board == game.board
  end

  def number_of_tiles_with_value(board, value) do
    assert length(board |> List.flatten() |> Enum.filter(&(&1 == value)))
  end
end
