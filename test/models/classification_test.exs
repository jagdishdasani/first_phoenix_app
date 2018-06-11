defmodule DataMonitor.ClassificationTest do
  use DataMonitor.ModelCase

  alias DataMonitor.Classification

  @valid_attrs %{classification_type: "some classification_type", code: 42, name: "some name", parent_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Classification.changeset(%Classification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Classification.changeset(%Classification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
