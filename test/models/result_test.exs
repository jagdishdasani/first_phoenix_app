defmodule DataMonitor.ResultTest do
  use DataMonitor.ModelCase

  alias DataMonitor.Result

  @valid_attrs %{company_name: "some company_name", is_blank: true, is_negative: true, is_zero: true, max_val: 120.5, min_val: 120.5, mnemonic: "some mnemonic", period: 42, uid: 42, unmatched_max_val: true, unmatched_min_val: true, value: 120.5}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Result.changeset(%Result{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Result.changeset(%Result{}, @invalid_attrs)
    refute changeset.valid?
  end
end
