defmodule Mix.Tasks.DataMonitor.LoadClassifications do
  use Mix.Task

  alias DataMonitor.{
    Classification,
    Repo
  }

  @core_engine Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine]

  require Logger

  @shortdoc "Loads classifications from classifications.csv"

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:data_monitor)

    if length(args) > 0 && hd(args) == "api" do
      {:ok, result} = @core_engine.get_data('classifications')

      file = File.open!("files/classifications.csv", [:write, :utf8])

      csv_header = ["code", "name", "classification_type", "parent_id"]

      classifications = Poison.decode!(result, as: [Classification])

      Enum.reduce(classifications, [csv_header], fn data_row, new ->
        new ++ [data_row]
      end)
      |> CSV.encode()
      |> Enum.each(&IO.write(file, &1))
    end

    columns = "code,name,classification_type,parent_id"

    stream =
      Ecto.Adapters.SQL.stream(
        Repo,
        "COPY classifications(#{columns}) FROM STDIN CSV HEADER"
      )

    Repo.transaction(fn ->
      Repo.delete_all(Classification)
      Enum.into(File.stream!("files/classifications.csv"), stream)
    end)
  end
end
