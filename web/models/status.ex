defmodule Status do
  use Ecto.Model

  schema "statuses" do
    field :text, :string
  end
end
