import Config

config :ex_whalefin_api_wrapper,
  path_prefix: "/api/v2"

import_config "#{Mix.env()}.exs"
import_config "secret.exs"
