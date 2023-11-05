# 2048

2048 is an Elixir based implementation of the popular tile swiping game.

The app is available [here](https://divine-grass-2423.fly.dev/).

The implementation makes the following behaviour choices:
 - allows the user to choose the grid size, with support size from 2 to 7
 - starts the game with a single tile with a value of 2
 - adds a new tile with a value of 1 whenever an input will update the state of the grid
 - supports swipe touch gestures
 - supports arrow key inputs

The structure of this repository keeps the core game logic in the game_2048 application. This core logic is consumed and presented in a phoenix live view application named b1.


## Prerequisites

This project requires:
 - Elixir 1.14.0
 - Erlang/OTP 25.0.4

## Installation
```bash
cd b1
mix setup
```

## Running locally

```bash
cd b1
mix phx.server
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
