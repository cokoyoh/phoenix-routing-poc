defmodule Spoti.PreflightFetchers.FABL do
  @base_url Application.compile_env(:spoti_web, :fabl_base_url)

  def fetch(opts, _config) do
    module = Keyword.fetch!(opts, :module)
    conn   = Keyword.fetch!(opts, :conn)

    params =
      conn.query_params
      |> Map.merge(conn.path_params)

    query = %{
      "path" => conn.request_path,
      "params" => params
    }

    url = "#{@base_url}/module/#{module}"

    case Req.get(url, params: query) do
      {:ok, %{status: 200, body: body}} -> {:ok, body}
      _ -> :error
    end
  end
end
