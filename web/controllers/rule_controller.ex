defmodule DataMonitor.RuleController do
  use DataMonitor.Web, :controller

  alias DataMonitor.{Rule, Mnemonic}
  require Logger

  def search_mnemonic(conn, %{"keyword" => keyword}) do
    mnemonics = load_mnemonics(keyword)
    json(conn, mnemonics)
  end

  def index(conn, _params) do
    rules = Repo.all(Rule)
    render(conn, "index.html", rules: rules)
  end

  def new(conn, _params) do
    changeset = Rule.changeset(%Rule{})
    mnemonics = load_mnemonics()
    render(conn, "new.html", changeset: changeset, mnemonics: mnemonics)
  end

  def create(conn, %{"rule" => rule_params}) do
    changeset = Rule.changeset(%Rule{}, rule_params)
    mnemonics = load_mnemonics()

    case Repo.insert(changeset) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule created successfully.")
        |> redirect(to: rule_path(conn, :show, rule))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, mnemonics: mnemonics)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)
    render(conn, "show.html", rule: rule)
  end

  def edit(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule)
    mnemonics = load_mnemonics()
    render(conn, "edit.html", rule: rule, changeset: changeset, mnemonics: mnemonics)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule, rule_params)
    mnemonics = load_mnemonics()

    case Repo.update(changeset) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule updated successfully.")
        |> redirect(to: rule_path(conn, :show, rule))

      {:error, changeset} ->
        render(conn, "edit.html", rule: rule, changeset: changeset, mnemonics: mnemonics)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rule)

    conn
    |> put_flash(:info, "Rule deleted successfully.")
    |> redirect(to: rule_path(conn, :index))
  end

  def load_mnemonics() do
    Repo.all(from(m in Mnemonic, select: map(m, [:mnemonic, :mnemonic]), order_by: m.mnemonic))
  end

  def load_mnemonics(keyword) do
    Repo.all(
      from(
        m in Mnemonic,
        select: %{name: m.mnemonic, id: m.mnemonic},
        where: ilike(m.mnemonic, ^"%#{keyword}%"),
        order_by: m.mnemonic
      )
    )
  end
end
