defmodule DataMonitor.CoreEngineRemote do
  alias DataMonitor.HttpClient
  alias DataMonitor.DataParser

  require Logger

  def core_engine_host,
    do: Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine_host]

  def core_engine_port,
    do: Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine_port]

  def core_engine_prefix,
    do: Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine_prefix]

  def auth_headers, do: Application.get_env(:data_monitor, DataMonitor.Endpoint)[:auth_headers]

  def core_engine_url, do: "#{core_engine_host()}:#{core_engine_port()}/#{core_engine_prefix()}"

  def get_company_metadatas({:ok, rule_set}, company_id, auth_headers) do
    if rule_set.frequency == "annual" do
      {:ok, response} =
        build_mcr_urls()
        |> HttpClient.post(build_params_mcr_data(rule_set, company_id), auth_headers)

      if String.length(response) > 10,
        do: DataParser.parseresponse({:ok, response}, rule_set),
        else: []
    else
      {:ok, response} =
        build_company_metadata_urls(rule_set, company_id)
        |> HttpClient.get(auth_headers)

      if String.length(response) > 10,
        do: DataParser.parseresponse({:ok, response}, rule_set),
        else: []
    end
  end

  def build_company_metadata_urls(rule_set, company_id) do
    url =
      "#{core_engine_url()}/admin/mnemonics?company_id=#{company_id}&data_items=#{
        rule_set.mnemonics |> Enum.join(",")
      }&start_year=#{rule_set.start_year}&end_year=#{rule_set.end_year}&frequency=#{
        rule_set.frequency
      }"

    Logger.info(":::::::::API URL Mnemonics :::::::::")
    Logger.info(inspect(url))

    {:ok, url}
  end

  def build_mcr_urls() do
    url = "#{core_engine_url()}/common/multi_company_report?"

    Logger.info(":::::::::API URL MCR :::::::::")
    Logger.info(inspect(url))

    {:ok, url}
  end

  def build_params_mcr_data(rule_set, company_id) do
    Poison.encode!(%{
      datapoints: rule_set.mnemonics,
      companies: [company_id],
      currency: "USD",
      start_year: String.to_integer(rule_set.start_year),
      end_year: String.to_integer(rule_set.end_year)
    })
  end

  def get_data(model) do
    url = "#{core_engine_url()}/admin/all_#{model}"

    HttpClient.get({:ok, url}, auth_headers())
  end
end
