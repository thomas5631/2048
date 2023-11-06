defmodule BrowserClientWeb.LiveGameTest do
  use BrowserClientWeb.ConnCase, async: true

  import Mock
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint BrowserClientWeb.Endpoint

  test "renders 2048 heading", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "2048"
  end

  test "clicking a size selector starts a game", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)

    assert view |> element("#board") |> has_element?()
  end

  test "starting a game hides the size selectors", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)

    for size <- ["2", "3", "4", "5", "6", "7"] do
      refute view |> element("button", "#{size} x #{size}") |> has_element?()
    end
  end

  test "starting a game displays the score", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)

    assert view |> element("div", "Current score") |> has_element?()
    assert view |> element("div", "2") |> has_element?()
  end

  test "starting a game displays the controls", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)

    for direction <- ["Left", "Right", "Up", "Down"] do
      assert view |> element("button", direction) |> has_element?()
    end
  end

  test "clicking a control renders a new tile with a value of 1", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)
    click_left_then_right(view)

    assert view |> element("div", "1") |> has_element?()
  end

  test "moving with arrow keys renders a new tile with a value of 1", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)
    start_game(view)
    key_left_then_right(view)

    assert view |> element("div", "1") |> has_element?()
  end

  test "the win screen is displayed when the game is in the won state", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)

    with_mock Game2048, won_game_mock() do
      start_game(view)
      assert view |> element("div", "You win!") |> has_element?()
    end
  end

  test "the lose screen is displayed when the game is in the lost state", %{conn: conn} do
    conn = get(conn, "/")
    {:ok, view, _html} = live(conn)

    with_mock Game2048, lost_game_mock() do
      start_game(view)
      assert view |> element("div", "You lose") |> has_element?()
    end
  end

  def start_game(view, size \\ 2) do
    size_as_string = Integer.to_string(size)
    view |> element("button", "#{size_as_string} x #{size_as_string}") |> render_click()
  end

  @doc """
  Since the tile starting positions are random, we move the tiles
  both left and right with buttons.

  This ensures a new tile is generated.
  """
  def click_left_then_right(view) do
    view
    |> element("button", "Left")
    |> render_click

    view
    |> element("button", "Right")
    |> render_click
  end

  @doc """
  Since the tile starting positions are random, we move the tiles
  both left and right with arrow keys.

  This ensures a new tile is generated.
  """
  def key_left_then_right(view) do
    view
    |> element("#game")
    |> render_keyup(%{key: "ArrowLeft"})

    view
    |> element("#game")
    |> render_keyup(%{key: "ArrowRight"})
  end

  def won_game_mock() do
    [
      status: fn _game ->
        %{game_state: :won, previous_move: :left, score: 2048, board: [[2048, 0], [0, 0]]}
      end,
      new_game: fn _size -> self() end
    ]
  end

  def lost_game_mock() do
    [
      status: fn _game ->
        %{game_state: :lost, previous_move: :left, score: 29, board: [[16, 1], [4, 8]]}
      end,
      new_game: fn _size -> self() end
    ]
  end
end
