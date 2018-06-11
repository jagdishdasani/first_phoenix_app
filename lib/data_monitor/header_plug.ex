defmodule DataMonitor.HeaderPlug do
  import Plug.Conn
  use Plug.Builder

  require Logger

  def set_header(conn, _opts) do
    conn
    |> put_req_header("x-seneca-email", "dev_robot@bar.com")
    |> put_req_header("x-cpat-charge-code", "CC12345")
    |> put_req_header(
      "authorization",
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJuaWNrbmFtZSI6ImRldl9yb2JvdCIsImlhdCI6MTUyMjY4NTQxOH0.VMOG6KEDNVAVzmegXR5jJjl9Guc5nqAdiGzcg81UBrI"
    )
  end
end
