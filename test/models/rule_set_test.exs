defmodule DataMonitor.RuleSetTest do
  use DataMonitor.ModelCase

  alias DataMonitor.RuleSet

  @valid_attrs %{
    classification_code: 42,
    end_year: "some end_year",
    frequency: "some frequency",
    mnemonics: ["some mnemonic", "another mnemonic"],
    start_year: "some start_year"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RuleSet.changeset(%RuleSet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleSet.changeset(%RuleSet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
