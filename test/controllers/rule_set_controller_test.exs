defmodule DataMonitor.RuleSetControllerTest do
  use DataMonitor.ConnCase

  alias DataMonitor.{RuleSet, RuleSetController}

  @valid_attrs %{
    classification_code: 42,
    end_year: "some end_year",
    frequency: "some frequency",
    mnemonics: ["some mnemonic", "another mnemonic"],
    start_year: "some start_year"
  }
  @invalid_attrs %{}

  @classifications [
                     %{code: 10, name: "Energy", classification_type: "gics", parent_id: ""},
                     %{code: 1010, name: "Energy", classification_type: "gics", parent_id: 10}
                   ]
                   |> Enum.map(&{&1.name, &1.code})

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, rule_set_path(conn, :index))
    assert html_response(conn, 200) =~ "Rule Sets"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get(conn, rule_set_path(conn, :new))
    assert html_response(conn, 200) =~ "New rule set"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post(conn, rule_set_path(conn, :create), rule_set: @valid_attrs)
    rule_set = Repo.get_by!(RuleSet, @valid_attrs)
    assert redirected_to(conn) == rule_set_path(conn, :show, rule_set.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, rule_set_path(conn, :create), rule_set: @invalid_attrs)
    assert html_response(conn, 200) =~ "New rule set"
  end

  test "shows chosen resource", %{conn: conn} do
    rule_set = Repo.insert!(%RuleSet{})
    conn = get(conn, rule_set_path(conn, :show, rule_set))
    assert html_response(conn, 200) =~ "Show rule set"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, rule_set_path(conn, :show, -1))
    end)
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    rule_set = Repo.insert!(%RuleSet{})
    conn = get(conn, rule_set_path(conn, :edit, rule_set))
    assert html_response(conn, 200) =~ "Edit rule set"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    rule_set = Repo.insert!(%RuleSet{})
    conn = put(conn, rule_set_path(conn, :update, rule_set), rule_set: @valid_attrs)
    assert redirected_to(conn) == rule_set_path(conn, :show, rule_set)
    assert Repo.get_by(RuleSet, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    rule_set = Repo.insert!(%RuleSet{})
    classifications = @classifications

    conn =
      put(
        conn,
        rule_set_path(conn, :update, rule_set),
        rule_set: @invalid_attrs
      )

    assert html_response(conn, 200) =~ "Edit rule set"
  end

  test "deletes chosen resource", %{conn: conn} do
    rule_set = Repo.insert!(%RuleSet{})
    conn = delete(conn, rule_set_path(conn, :delete, rule_set))
    assert redirected_to(conn) == rule_set_path(conn, :index)
    refute Repo.get(RuleSet, rule_set.id)
  end
end
