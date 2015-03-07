defmodule Timeline.Repo.Migrations.AddSourceFieldsToStatuses do
  use Ecto.Migration

  def change do
    alter table(:statuses) do
      add :source_type, :string
      add :source_id, :string
      add :posted_at, :datetime
    end
  end
end
