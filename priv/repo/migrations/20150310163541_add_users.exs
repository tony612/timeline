defmodule Timeline.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :nick, :string
    end
  end
end
