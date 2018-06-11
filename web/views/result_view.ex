defmodule DataMonitor.ResultView do
  use DataMonitor.Web, :view

  def boolean_to_yes_no(condition) do
    if condition do
      "Yes"
    end
  end
end
