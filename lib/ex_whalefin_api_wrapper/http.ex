defmodule ExWhalefinApiWrapper.HTTP do
  def request(method, path, params, body \\ nil) do
    base_url =
      Application.get_env(:ex_whalefin_api_wrapper, :base_url) || "https://be-alpha.whalefin.com"

    path_prefix = Application.get_env(:ex_whalefin_api_wrapper, :path_prefix) || "/api/v2"

    access_key = Application.get_env(:ex_whalefin_api_wrapper, :access_key) || ""

    access_secret = Application.get_env(:ex_whalefin_api_wrapper, :access_secret) || ""

    full_path =
      if map_size(params) == 0 do
        path_prefix <> path
      else
        query_string =
          params
          |> Enum.map(fn {key, value} ->
            Atom.to_string(key) <> "=" <> value
          end)
          |> Enum.join("&")

        path_prefix <> path <> "?" <> query_string
      end

    method_string = method |> Atom.to_string() |> String.upcase()

    access_timestamp = :os.system_time(:micro_seconds) |> Integer.to_string()

    sign_string = "method=#{method_string}&path=#{full_path}&timestamp=#{access_timestamp}"

    access_sign =
      :crypto.mac(:hmac, :sha256, access_secret, sign_string)
      |> Base.encode16(case: :lower)

    headers = [
      {"access-key", access_key},
      {"access-timestamp", access_timestamp},
      {"access-sign", access_sign}
    ]

    Finch.build(method, base_url <> full_path, headers, body)
    |> Finch.request(FincHTTP)
  end

  def get(path, params \\ %{}) do
    request(:get, path, params)
  end

  def post(path, body, params \\ %{}) do
    request(:post, path, params, body)
  end

  def put(path, body, params \\ %{}) do
    request(:put, path, params, body)
  end
end
