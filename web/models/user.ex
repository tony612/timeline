defmodule Timeline.User do
  use Ecto.Model

  schema "users" do
    field :email, :string
    field :nick, :string

    has_many :statuses, Status

    timestamps
  end
end
