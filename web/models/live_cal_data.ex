defmodule DataMonitor.LiveCalData do
  @derive [Poison.Encoder]

  defstruct [
    :mnemonic,
    :period,
    :value,
    :date,
    :currency,
    :name,
    :type,
    :uid
  ]
end
