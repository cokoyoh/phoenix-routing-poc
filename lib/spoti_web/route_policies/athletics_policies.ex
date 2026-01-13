defmodule SpotiWeb.RoutePolicies.AthleticsPolicy do
  @test_only MapSet.new(~w(gor-mahia couch-preview experimental))

  def allowed?(:test, _name), do: true

  def allowed?(:prod, name) do
    not MapSet.member?(@test_only, name)
  end
end
