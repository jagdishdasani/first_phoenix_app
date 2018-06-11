defmodule DataMonitor.ResultController do
  use DataMonitor.Web, :controller

  alias DataMonitor.{
    Result
  }

  require Logger

  def index(conn, _params) do
    query =
      "SELECT count(*) uid, count(DISTINCT company_name) company_name, inserted_at::timestamp::DATE AS inserted_at FROM results GROUP BY inserted_at::timestamp::DATE ORDER BY inserted_at desc"

    results = Ecto.Adapters.SQL.query!(Repo, query)
    cols = Enum.map(results.columns, &String.to_atom(&1))

    data =
      Enum.map(results.rows, fn row ->
        struct(DataMonitor.Result, Enum.zip(cols, row))
      end)

    render(conn, "index.html", results: data)
  end

  def summary(conn, %{"date" => date}) do
    query =
      "SELECT count(uid) as value, company_name, uid, inserted_at::timestamp::DATE as inserted_at FROM results 
       WHERE inserted_at::timestamp::DATE = '#{date}' 
       GROUP BY company_name, uid, inserted_at::timestamp::DATE order by value desc"

    results = Ecto.Adapters.SQL.query!(Repo, query)
    cols = Enum.map(results.columns, &String.to_atom(&1))

    data =
      Enum.map(results.rows, fn row ->
        struct(DataMonitor.Result, Enum.zip(cols, row))
      end)

    render(conn, "summary.html", results: data, date: date)
  end

  def download_csv(conn, params) do
    date = params["date"]
    uid = params["uid"]
    filename = if uid != nil, do: "#{date}-#{uid}", else: "#{date}"

    query =
      if uid != nil,
        do:
          "SELECT * FROM results WHERE inserted_at::timestamp::DATE = '#{date}' and uid = #{uid}",
        else: "SELECT * FROM results WHERE inserted_at::timestamp::DATE = '#{date}' "

    results = Ecto.Adapters.SQL.query!(Repo, query)
    cols = Enum.map(results.columns, &String.to_atom(&1))

    data =
      Enum.map(results.rows, fn row ->
        struct(DataMonitor.Result, Enum.zip(cols, row))
      end)
      |> Result.csv_content()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}.csv\"")
    |> send_resp(200, data)
  end
end
