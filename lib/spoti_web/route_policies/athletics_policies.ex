defmodule SpotiWeb.RoutePolicies.AthleticsPolicy do
  @test_only ~w(gor-mahia couch-preview experimental)

  def allowed?(env, name) do
    case env do
      :test -> true
      :prod -> name not in @test_only
    end
  end
end
