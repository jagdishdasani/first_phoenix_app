defmodule Mix.Tasks.DataMonitor.LoadMnemonics do
  use Mix.Task

  alias DataMonitor.{
    Mnemonic,
    Repo
  }

  @core_engine Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine]

  require Logger

  @shortdoc "Loads mnemonics from mnemonics.csv"

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:data_monitor)

    if length(args) > 0 && hd(args) == "api" do
      {:ok, result} = @core_engine.get_data('mnemonics')

      file = File.open!("files/mnemonics.csv", [:write, :utf8])
      csv_header = ["mnemonic", "unit", "inserted_at", "updated_at"]

      mnemonics = Poison.decode!(result, as: [Mnemonic])

      Enum.reduce(mnemonics, [csv_header], fn data_row, new ->
        new ++ [data_row]
      end)
      |> CSV.encode()
      |> Enum.each(&IO.write(file, &1))
    end

    columns = "mnemonic,unit,inserted_at,updated_at"

    stream =
      Ecto.Adapters.SQL.stream(
        Repo,
        "COPY mnemonics(#{columns}) FROM STDIN CSV HEADER"
      )

    Repo.transaction(fn ->
      Repo.delete_all(Mnemonic)
      Enum.into(File.stream!("files/mnemonics.csv"), stream)
    end)
  end
end
