defmodule DataMonitor.RuleSetController do
  use DataMonitor.Web, :controller
  import DataMonitor.HeaderPlug

  plug(:set_header)

  alias DataMonitor.{
    RuleSet,
    Company,
    Rule,
    RuleSender,
    Classification
  }

  require Logger

  def search_code(conn, %{"keyword" => keyword}) do
    classifications = load_classifications(keyword)
    json(conn, classifications)
  end

  def index(conn, _params) do
    rule_sets =
      Repo.all(RuleSet)
      |> Repo.preload(:classification)

    render(conn, "index.html", rule_sets: rule_sets)
  end

  def new(conn, _params) do
    changeset = RuleSet.changeset(%RuleSet{})
    
    classifications = load_classifications()
    frequencies = load_frequencies()
    mnemonics = load_mnemonics()

    render(
      conn,
      "new.html",
      changeset: changeset,
      classifications: classifications,
      mnemonics: mnemonics,
      frequencies: frequencies
    )
  end

  def create(conn, %{"rule_set" => rule_set_params}) do
    changeset = RuleSet.changeset(%RuleSet{}, rule_set_params)
    classifications = load_classifications()
    frequencies = load_frequencies()
    mnemonics = load_mnemonics()

    case Repo.insert(changeset) do
      {:ok, rule_set} ->
        conn
        |> put_flash(:info, "Rule set created successfully.")
        |> redirect(to: rule_set_path(conn, :show, rule_set))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          classifications: classifications,
          mnemonics: mnemonics,
          frequencies: frequencies
        )
    end
  end

  def show(conn, %{"id" => id}) do
    rule_set =
      Repo.get!(RuleSet, id)
      |> Repo.preload(:classification)

    render(conn, "show.html", rule_set: rule_set)
  end

  def edit(conn, %{"id" => id}) do
    rule_set =
      Repo.get!(RuleSet, id)
      |> Repo.preload(:classification)

    changeset = RuleSet.changeset(rule_set)

    classifications = load_classifications()
    frequencies = load_frequencies()
    mnemonics = load_mnemonics()

    render(
      conn,
      "edit.html",
      rule_set: rule_set,
      changeset: changeset,
      classifications: classifications,
      mnemonics: mnemonics,
      frequencies: frequencies
    )
  end

  def update(conn, %{"id" => id, "rule_set" => rule_set_params}) do
    rule_set =
      Repo.get!(RuleSet, id)
      |> Repo.preload(:classification)

    changeset = RuleSet.changeset(rule_set, rule_set_params)

    case Repo.update(changeset) do
      {:ok, rule_set} ->
        conn
        |> put_flash(:info, "Rule set updated successfully.")
        |> redirect(to: rule_set_path(conn, :show, rule_set))

      {:error, changeset} ->
        render(conn, "edit.html", rule_set: rule_set, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule_set =
      Repo.get!(RuleSet, id)
      |> Repo.preload(:classification)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rule_set)

    conn
    |> put_flash(:info, "Rule set deleted successfully.")
    |> redirect(to: rule_set_path(conn, :index))
  end

  @doc """
  This function to run set of rules on single company
  """
  def run(conn, %{"id" => id}) do
    rule_set =
      Repo.get!(RuleSet, id)
      |> Repo.preload(:classification)

    rule_sets =
      Repo.all(RuleSet)
      |> Repo.preload(:classification)

    RuleSender.perform(rule_set)

    conn
    |> put_flash(:info, "Rule set executed successfully for #{rule_set.classification.name}.")
    |> redirect(to: rule_set_path(conn, :index, rule_sets))
  end

  @doc """
  This function to load list of classifications
  """
  def load_classifications() do
    sub_query =
      Repo.all(
        from(
          c in Company,
          select: c.level_three_id,
          where: not is_nil(c.level_three_id),
          distinct: true
        )
      )

    Repo.all(
      from(
        c in Classification,
        select: map(c, [:name, :id]),
        where: c.code in ^sub_query,
        order_by: c.name
      )
    )
    |> Enum.map(&{&1.name, &1.id})
  end

  def load_classifications(keyword) do
    sub_query =
      Repo.all(
        from(
          c in Company,
          select: c.level_three_id,
          where: not is_nil(c.level_three_id),
          distinct: true
        )
      )

    Repo.all(
      from(
        c in Classification,
        select: %{name: c.name, id: c.id},
        where: ilike(c.name, ^"%#{keyword}%"),
        where: c.code in ^sub_query,
        order_by: c.name
      )
    )

    # |> Enum.map(&{&1.name, &1.code})
  end

  @doc """
  This function to load list of frequencies
  """
  def load_frequencies do
    %{
      "Annual" => "annual",
      "Daily" => "daily",
      "Monthly" => "monthly",
      "Quarterly" => "quarterly"
    }
  end

  @doc """
  This function to load list of Rule mnemonic wise
  """
  def load_mnemonics do
    Repo.all(from(r in Rule, order_by: r.mnemonic))
    |> Enum.map(&{&1.description, &1.mnemonic})
  end

  # def download_csv(conn, %{"id" => id}) do
  #   rule_set = Repo.get!(RuleSet, id)

  #   file = File.read!("files/#{rule_set.company_id}.csv")

  #   conn
  #   |> put_resp_content_type("text/csv")
  #   |> put_resp_header(
  #     "content-disposition",
  #     "attachment; filename=\"#{rule_set.company_id}.csv\""
  #   )
  #   |> send_resp(200, file)
  # end
end
