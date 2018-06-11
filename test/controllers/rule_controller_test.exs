defmodule DataMonitor.RuleControllerTest do
  use DataMonitor.ConnCase

  alias DataMonitor.Rule

  @valid_attrs %{
    can_blank: true,
    can_negative: true,
    can_zero: true,
    description: "some description",
    unit: "In Millions",
    max_val: 120.5,
    min_val: 120.5,
    mnemonic: "some mnemonic"
  }
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, rule_path(conn, :index))
    assert html_response(conn, 200) =~ "Mnemonic Rules"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get(conn, rule_path(conn, :new))
    assert html_response(conn, 200) =~ "New rule"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post(conn, rule_path(conn, :create), rule: @valid_attrs)
    rule = Repo.get_by!(Rule, @valid_attrs)
    assert redirected_to(conn) == rule_path(conn, :show, rule.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, rule_path(conn, :create), rule: @invalid_attrs)
    assert html_response(conn, 200) =~ "New rule"
  end

  test "shows chosen resource", %{conn: conn} do
    rule = Repo.insert!(%Rule{})
    conn = get(conn, rule_path(conn, :show, rule))
    assert html_response(conn, 200) =~ "Show rule"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, rule_path(conn, :show, -1))
    end)
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    rule = Repo.insert!(%Rule{})
    conn = get(conn, rule_path(conn, :edit, rule))
    assert html_response(conn, 200) =~ "Edit rule"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    rule = Repo.insert!(%Rule{})
    conn = put(conn, rule_path(conn, :update, rule), rule: @valid_attrs)
    assert redirected_to(conn) == rule_path(conn, :show, rule)
    assert Repo.get_by(Rule, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    rule = Repo.insert!(%Rule{})
    conn = put(conn, rule_path(conn, :update, rule), rule: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit rule"
  end

  test "deletes chosen resource", %{conn: conn} do
    rule = Repo.insert!(%Rule{})
    conn = delete(conn, rule_path(conn, :delete, rule))
    assert redirected_to(conn) == rule_path(conn, :index)
    refute Repo.get(Rule, rule.id)
  end
end
