defmodule UserPortal.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:account_users) do
      add :name, :string
      add :username, :string
      add :email, :string
      add :token, :string
      add :email_verified, :boolean
      add :password_hash, :string
      timestamps()
    end
    create unique_index(:account_users, [:email, :username])
  end
end
