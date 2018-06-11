defmodule DataMonitor.DataParser do
  alias DataMonitor.LiveCalData

  require Logger

  def parseresponse({:ok, response}, rule_set) do
    apply(DataMonitor.DataParser, String.to_atom(rule_set.frequency), [response])
  end

  def daily(response) do
    Poison.decode!(response, as: [%LiveCalData{}])
  end

  def monthly(response) do
    Poison.decode!(response, as: [%LiveCalData{}])
  end

  def quarterly(response) do
    Poison.decode!(response, as: [%LiveCalData{}])
  end

  def annual(response) do
    datapoints = Poison.decode!(response) |> Map.fetch!("datapoints")

    Enum.reduce(datapoints, [], fn mnemonic_map, result ->
      result ++ create_live_cal_data_list(mnemonic_map)
    end)
  end

  def create_live_cal_data_list(mnemonic_map) do
    mnemonic_name = Map.fetch!(mnemonic_map, "mnemonic")
    values = Map.fetch!(mnemonic_map, "values")

    if values != nil && length(values) > 0 do
      Enum.reduce(values, [], fn row, live_cal_data_list ->
        live_cal_data_list ++ [creat_live_cal(mnemonic_name, row)]
      end)
    else
      []
    end
  end

  def creat_live_cal(mnemonic, row) do
    live_cal_data = %LiveCalData{
      mnemonic: mnemonic,
      period: row["period"],
      value: row["value"],
      date: row["date"],
      currency: "USD",
      name: row["name"],
      type: row["type"],
      uid: row["uid"]
    }

    live_cal_data
  end
end
