defmodule Timeline.Status do
  use Ecto.Model

  schema "statuses" do
    field :text, :string

    field :source_type, :string
    field :source_id, :string
    field :posted_at, :datetime

    timestamps
  end
end
