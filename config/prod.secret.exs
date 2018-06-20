use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :platform, PlatformWeb.Endpoint,
  secret_key_base: "Dr1VGbo8kELgEKu/DK2VgaYAD09+hU5ScMjs4e1xUTeW9oe6FycAIdFVQAUvcfWa"

# Configure your database
config :platform, Platform.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ecto",
  password: "19216801995",
  database: "platform_prod",
  pool_size: 15
