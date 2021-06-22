defmodule UserPortal.Account.User do
  use Ecto.Schema
  import  Ecto.Changeset
  alias UserPortal.Account.User
  schema "account_users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email_verified, :boolean
    field :token, :string
    timestamps()
  end
  def changeset(%User{} = user, params) do
    user
    |> cast(params, [:name, :email, :username])
    |> validate_required([:name, :username, :email])
    |> validate_length(:username, min: 5, max: 20)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_not_verified()
    |> put_token()
  end
  defp put_not_verified(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :email_verified, false)
      _ ->
        changeset
    end
  end
  defp put_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :token, SecureRandom.urlsafe_base64())
      _ ->
        changeset
    end
  end
  def registration_changeset(model, params \\ %{}) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 4, max: 200)
    |> put_pass_hash()
  end
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Hasher.salted_password_hash(password))
      _ ->
        changeset
    end
  end
  def verify_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [])
    |> put_verify_email()
  end
  defp put_verify_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :email_verified, true)
      _ ->
        changeset
    end
  end
end