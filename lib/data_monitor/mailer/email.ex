defmodule DataMonitor.Email do
  import Swoosh.Email
  require Logger

  def report_email(file_path) do
    new()
    |> to("jagdish.dasani@gmail.com")
    |> from({"Data Monitor", "tony.stark@example.com"})
    |> subject("Data monitor report!!!")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
    |> attachment(file_path)
  end
end
