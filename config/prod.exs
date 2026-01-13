import Config

config :spoti_web,
  env: :prod,
  allowed_hosts: ~r/(^spoti\.co\.ke$|.*\.live\.spoti\.co\.ke)/,
  webcore_url: "https://webcore.live.spoti.co.ke",
  legacy_url: "https://legacy.live.spoti.co.ke",
  fabl_base_url: "https://fabl.live.api.spoti.co.ke"

config :spoti_web, Spoti.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  server: true

config :logger, :default_formatter,
  format: "[$level] $message $metadata\n",
  metadata: [:request_id, :url, :query, :method, :status, :env, :target, :body, :data, :reason, :timeout]
