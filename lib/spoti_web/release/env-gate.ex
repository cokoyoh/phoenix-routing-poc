defmodule Spoti.EnvGate do
  defstruct allow: MapSet.new()

  def new(opts) do
    %__MODULE__{
      allow: MapSet.new(Keyword.get(opts, :allow, []))
    }
  end

  def allowed?(%__MODULE__{allow: set}, value) do
    MapSet.member?(set, value)
  end
end
