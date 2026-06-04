defmodule FindStatePlates.AccountsFixtures do
  @moduledoc false

  alias FindStatePlates.Accounts

  def unique_user_email, do: "user#{System.unique_integer([:positive])}@example.com"
  def valid_user_password, do: "super-secret-1234"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: unique_user_email(), password: valid_user_password()})
      |> Accounts.register_user()

    user
  end
end
