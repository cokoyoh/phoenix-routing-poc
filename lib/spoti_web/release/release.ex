defmodule Spoti.Release do
  @type target :: :webcore | :legacy

  def static(target), do: fn _env, _data -> target end

  def by_env(map), do: fn env, _data -> Map.fetch!(map, env) end

  def by_runtime(fun), do: fn _env, data -> fun.(data) end

  def env_then_runtime(test_target, fun) do
    fn
      :test, _data -> test_target
      _env, data -> fun.(data)
    end
  end
end
