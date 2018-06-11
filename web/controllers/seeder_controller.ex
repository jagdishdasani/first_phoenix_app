defmodule DataMonitor.SeederController do 
	use DataMonitor.Web, :controller
	alias DataMonitor.{
		Mnemonic,
		Classification,
		Company
	}

	def seed_data(conn, %{"model" => model}) do
		if model == "mnemonic", do: load_mnemonics()
		if model == "classification", do: load_classifications()
		if model == "company", do: load_companies()
		render(conn, "index.html", model: model)
	end

	def load_mnemonics() do
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

	def load_classifications() do
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

	def load_companies() do 
		columns = "name,uid,level_one_id,level_two_id,level_three_id,level_four_id,is_active"

	    stream =
	      Ecto.Adapters.SQL.stream(
	        Repo,
	        "COPY companies(#{columns}) FROM STDIN CSV HEADER"
	      )

	    Repo.transaction(fn ->
	      Repo.delete_all(Company)
	      Enum.into(File.stream!("files/companies.csv"), stream)
	    end)

	    
	end

end