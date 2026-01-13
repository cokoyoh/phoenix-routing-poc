import Config

config :spoti_web,
  env: :test,
  allowed_hosts: ~r/.*\.test\.spoti\.co\.ke/,
  webcore_url: "http://localhost.spoti.co.ke:3300",
  legacy_url: "http://localhost.spoti.co.ke:3301",
  fabl_base_url: "https://fabl.test.api.spoti.co.ke"

config :spoti_web, SpotiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false
