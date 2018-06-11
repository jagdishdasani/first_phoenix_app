defmodule DataMonitor.PageController do
  use DataMonitor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
