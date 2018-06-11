defmodule DataMonitor.RuleTest do
  use DataMonitor.ModelCase

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

  test "changeset with valid attributes" do
    changeset = Rule.changeset(%Rule{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rule.changeset(%Rule{}, @invalid_attrs)
    refute changeset.valid?
  end
end
