defmodule Mix.Tasks.DataMonitor.LoadCompanies do
  use Mix.Task

  alias DataMonitor.{
    Company,
    Repo
  }

  @core_engine Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine]

  require Logger

  @shortdoc "Loads companies from companies.csv"

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:data_monitor)

    if length(args) > 0 && hd(args) == "api" do
      {:ok, result} = @core_engine.get_data('companies')

      file = File.open!("files/companies.csv", [:write, :utf8])

      csv_header = [
        "name",
        "uid",
        "level_one_id",
        "level_two_id",
        "level_three_id",
        "level_four_id",
        "is_active"
      ]

      companies = Poison.decode!(result, as: [Company])

      Enum.reduce(companies, [csv_header], fn data_row, new ->
        data_row = data_row ++ [true]
        new ++ [data_row]
      end)
      |> CSV.encode()
      |> Enum.each(&IO.write(file, &1))
    end

    columns = "name,uid,level_one_id,level_two_id,level_three_id,level_four_id,is_active"

    stream =
      Ecto.Adapters.SQL.stream(
        Repo,
        "COPY companies(#{columns}) FROM STDIN CSV HEADER"
      )

    Repo.transaction(fn ->
      Repo.delete_all(Company)
      Enum.into(File.stream!("files/companies.csv"), stream)
    end)
  end
end
