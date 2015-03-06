defmodule Timeline.Status do
  use Ecto.Model

  schema "statuses" do
    field :text, :string

    timestamps
  end
end
