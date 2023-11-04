defmodule Game2048.Impl.Board do
  alias Game2048.Type

  @type t :: [list(Integer)]

  @spec create(Integer.t()) :: t

  def create(size) when size < 2 do
    raise "Minimum board size is 2"
  end

  def create(size) when size > 7 do
    raise "Maximum board size is 7"
  end

  def create(size) do
    for(_ <- 1..size, do: [])
    |> Enum.map(fn _ -> for _ <- 1..size, do: 0 end)
  end

  @spec has_empty_space?(t) :: boolean

  def has_empty_space?(board) do
    board
    |> List.flatten()
    |> Enum.any?(&(&1 == 0))
  end

  @spec no_moves_remain?(t) :: boolean

  def no_moves_remain?(board) do
    Enum.all?([:up, :down, :left, :right], fn direction -> slide(board, direction) == board end)
  end

  @spec maybe_place_new_tile(t, Integer.t()) :: t

  def maybe_place_new_tile(board, tile) do
    place_new_tile(board, tile, has_empty_space?(board))
  end

  @spec place_new_tile(t, Integer.t(), boolean) :: t

  defp place_new_tile(board, tile, _has_empty_space = true) do
    board_size = length(board)
    flat_board = board |> List.flatten()
    random_empty_space = get_random_empty_space(flat_board)
    List.replace_at(flat_board, random_empty_space, tile) |> Enum.chunk_every(board_size)
  end

  defp place_new_tile(board, _tile, _has_empty_space = false) do
    board
  end

  @spec get_random_empty_space([Integer.t()]) :: Integer.t()

  defp get_random_empty_space(flat_board) do
    flat_board
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == 0 end)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.random()
  end

  @spec slide(t, Type.direction()) :: t

  def slide(board, :down) do
    board
    |> transpose
    |> Enum.map(fn row -> row |> Enum.reverse() |> slide_row_left() |> Enum.reverse() end)
    |> transpose
  end

  def slide(board, :up) do
    board |> transpose |> Enum.map(fn row -> slide_row_left(row) end) |> transpose
  end

  def slide(board, :right) do
    board |> Enum.map(fn row -> row |> Enum.reverse() |> slide_row_left() |> Enum.reverse() end)
  end

  def slide(board, :left) do
    board |> Enum.map(fn row -> slide_row_left(row) end)
  end

  @spec calculate_score(t) :: Integer.t()

  def calculate_score(board) do
    board |> List.flatten() |> Enum.reduce(0, &(&1 + &2))
  end

  @spec transpose(t) :: t

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @spec slide_row_left([Integer.t()]) :: [Integer.t()]

  defp slide_row_left(row) do
    original_size = length(row)

    row
    |> Enum.filter(&(&1 != 0))
    |> slide_and_merge()
    |> replenish_row(original_size)
  end

  @spec slide_and_merge([Integer.t()]) :: [Integer.t()]

  defp slide_and_merge([tile1 | [tile2 | rest] = _tiles]) when tile1 == tile2 do
    slide_and_merge([tile1 * 2 | rest])
  end

  defp slide_and_merge([tile1 | rest]) do
    [tile1 | slide_and_merge(rest)]
  end

  defp slide_and_merge([]) do
    []
  end

  defp replenish_row(row, original_size) do
    row ++ List.duplicate(0, original_size - length(row))
  end
end
