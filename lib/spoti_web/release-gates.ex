defmodule Spoti.ReleaseGates do
  def allowed?(gates, env, id) do
    case Map.get(gates, env) do
      nil -> true
      gate -> Spoti.EnvGate.allowed?(gate, id)
    end
  end
end
