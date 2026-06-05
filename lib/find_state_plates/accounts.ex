defmodule FindStatePlates.Accounts do
  import Ecto.Query, warn: false

  alias FindStatePlates.Accounts.{User, UserToken}
  alias FindStatePlates.Repo

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: String.downcase(email))
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = get_user_by_email(email)

    if User.valid_password?(user, password), do: user
  end

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def change_user_registration(user, attrs \\ %{}) do
    User.change_registration(user, attrs)
  end

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) when is_binary(token) do
    case UserToken.verify_session_token_query(token) do
      {:ok, query} -> Repo.one(query)
      :error -> nil
    end
  end

  def delete_user_session_token(token) when is_binary(token) do
    case UserToken.session_token_query(token) do
      {:ok, query} -> Repo.delete_all(query)
      :error -> {0, nil}
    end

    :ok
  end
end
