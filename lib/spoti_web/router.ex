scope "/", SpotiWeb do
  pipe_through :ingress

  get "/athletics", ForwardToWebcore

  get "/athletics/:name",
    AthleticsPolicyPlug,
    ForwardToWebcore
end
