defmodule FindStatePlates.AccountsTest do
  use FindStatePlates.DataCase, async: true

  alias FindStatePlates.Accounts
  alias FindStatePlates.Accounts.User

  import FindStatePlates.AccountsFixtures

  describe "register_user/1" do
    test "creates a user and hashes the password" do
      email = unique_user_email()

      assert {:ok, %User{} = user} =
               Accounts.register_user(%{email: email, password: valid_user_password()})

      assert user.email == String.downcase(email)
      assert user.hashed_password
      refute user.password
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "returns the user with valid credentials" do
      user = user_fixture()
      assert %User{id: ^user.id} = Accounts.get_user_by_email_and_password(user.email, valid_user_password())
    end

    test "returns nil with invalid credentials" do
      user = user_fixture()
      refute Accounts.get_user_by_email_and_password(user.email, "wrong-password")
    end
  end

  describe "session tokens" do
    test "round trips a session token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)

      assert %User{id: ^user.id} = Accounts.get_user_by_session_token(token)
      assert :ok = Accounts.delete_user_session_token(token)
      refute Accounts.get_user_by_session_token(token)
    end
  end
end
