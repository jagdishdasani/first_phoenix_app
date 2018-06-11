require IEx

defmodule DataMonitor.HttpClient do
  require Logger

  @request_timeout_millis 20000

  # @spec get({:ok, String.t()}, list(String.t())) :: {atom(), map()}
  def get({:ok, url}, headers) do
    options = [recv_timeout: @request_timeout_millis]

    conn = HTTPoison.get(url, headers, options)

    conn
    |> validate_connection(url)
    |> validate_response
    |> extract_body
  end

  def post({:ok, url}, body, headers) do
    headers = headers ++ [{"Content-Type", "application/json"}]
    conn = HTTPoison.post(url, body, headers, [])

    conn
    |> validate_connection(url)
    |> validate_response
    |> extract_body
  end

  def validate_connection({:ok, response}, _url), do: {:ok, response}

  def validate_connection({:error, _response}, url),
    do: {:error, "Could not connect to Core-engine: #{url}"}

  def validate_response({:ok, response = %{:status_code => 200}}) do
    {:ok, response}
  end

  def validate_response({:ok, response}),
    do: {:error, "Error from API response: #{response.status_code}"}

  def validate_response({:error, error}), do: {:error, error}

  defp extract_body({:ok, response}) do
    content_type = :proplists.get_value("Content-Type", response.headers)

    if response.body != nil && content_type != nil &&
         String.contains?(String.downcase(content_type), "application/json") do
      {:ok, response.body}
    else
      {:ok, response.body}
    end
  end

  defp extract_body({:error, reason}), do: {:error, reason}
end
