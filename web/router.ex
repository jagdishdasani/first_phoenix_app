defmodule DataMonitor.Router do
  use DataMonitor.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DataMonitor do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", RuleController, :index)
    resources("/rules", RuleController)
    resources("/rule_sets", RuleSetController)
    get("/search_mnemonic", RuleController, :search_mnemonic)
    get("/search_code", RuleSetController, :search_code)
    get("/run/:id", RuleSetController, :run)
    get("/results", ResultController, :index)
    get("/summary/:date", ResultController, :summary)
    # get("/download/:date/:uid", ResultController, :download_csv)
    get("/download/:date", ResultController, :download_csv)
    get("/seed_data/:model", SeederController, :seed_data)
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", DataMonitor do
  #   pipe_through :api
  # end
end
