import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :browser_client, BrowserClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BjTU6q/z6RbuM67qCEMsddpwFWTyL6QTgx866tU9P/9fkTOOnrxzheZP9moz1sU0",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
