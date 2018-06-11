defmodule DataMonitor.CompanyMetadata do
  @moduledoc """
  """

  @core_engine Application.get_env(:data_monitor, DataMonitor.Endpoint)[:core_engine]

  def get_metadata({:ok, rule_set}, company_id, auth_headers) do
    @core_engine.get_company_metadatas({:ok, rule_set}, company_id, auth_headers)
  end
end
