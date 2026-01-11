import Config

config :spoti_web,
  env: :prod,
  allowed_hosts: ~r/(^spoti\.co\.ke$|.*\.live\.spoti\.co\.ke)/,
  webcore_url: "http://localhost.spoti.co.ke:3300",
  legacy_url: "http://localhost.spoti.co.ke:3301"
