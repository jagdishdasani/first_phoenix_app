defmodule DataMonitor.MnemonicTest do
  use DataMonitor.ModelCase

  alias DataMonitor.Mnemonic

  @valid_attrs %{mnemonic: "some mnemonic", unit: "some unit"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Mnemonic.changeset(%Mnemonic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Mnemonic.changeset(%Mnemonic{}, @invalid_attrs)
    refute changeset.valid?
  end
end
