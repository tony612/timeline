defmodule Timeline.Repo.Migrations.AddUserIdToStatuses do
  use Ecto.Migration

  def change do
    alter table(:statuses) do
      add :user_id, :integer
    end
    create index(:statuses, [:user_id])
  end
end
