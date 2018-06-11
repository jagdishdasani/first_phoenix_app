# DataMonitor

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Mix tasks to dump data from csv file

  * `mix data_monitor.load_classifications` # Call API to core-engine and loads classifications 
  * `mix data_monitor.load_companies`       # Call API to core-engine loads companies 
  * `mix data_monitor.load_mnemonics`       # Call API to core-engine loads mnemonics 

Pass api to load data from core-engine instead of csv files
e.g `mix data_monitor.load_mnemonics api`

