defmodule FindStatePlates.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32
  @session_valid_days 60

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, FindStatePlates.Accounts.User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    encoded_token = Base.url_encode64(token, padding: false)

    {encoded_token,
     %__MODULE__{
       token: :crypto.hash(@hash_algorithm, token),
       context: "session",
       user_id: user.id
     }}
  end

  def verify_session_token_query(token) do
    with {:ok, decoded_token} <- Base.url_decode64(token, padding: false) do
      hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

      query =
        from token in by_token_and_context_query(hashed_token, "session"),
          join: user in assoc(token, :user),
          where: token.inserted_at > ago(@session_valid_days, "day"),
          select: user

      {:ok, query}
    else
      :error -> :error
    end
  end

  def session_token_query(token) do
    with {:ok, decoded_token} <- Base.url_decode64(token, padding: false) do
      hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
      {:ok, by_token_and_context_query(hashed_token, "session")}
    else
      :error -> :error
    end
  end

  defp by_token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end
end
