import Config

config :spoti_web,
  env: :prod,
  allowed_hosts: ~r/(^spoti\.co\.ke$|.*\.live\.spoti\.co\.ke)/,
  webcore_url: "https://webcore.live.spoti.co.ke",
  legacy_url: "https://legacy.live.spoti.co.ke"

config :spoti_web, SpotiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  server: true
