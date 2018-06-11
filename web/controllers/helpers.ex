defmodule DataMonitor.Controllers.Helpers do
  def only_auth_headers(request_headers) do
    auth_headers =
      Keyword.take(request_headers, ["x-cpat-charge-code", "authorization", "x-seneca-email"])

    Enum.map(auth_headers, fn {key, value} -> {String.to_atom(key), value} end)
  end
end
