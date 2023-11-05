defmodule B1Web.LiveGameTest do
  use B1Web.ConnCase, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint B1Web.Endpoint

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
end
