defmodule Timeline.Status do
  use Ecto.Model
  use Pipe

  alias Ecto.DateTime

  schema "statuses" do
    field :text, :string

    field :source_type, :string
    field :source_id, :string
    field :posted_at, :datetime

    belongs_to :user, Timeline.User

    timestamps
  end

  def jsonable(struct) do
    Enum.reduce [:inserted_at, :updated_at, :posted_at], struct, fn(k, s) ->
      case Map.get(s, k) do
        %DateTime{} = dt -> Map.put(s, k, DateTime.to_string(dt))
        dt = {date, time} ->
          ds = pipe_matching(x, {:ok, x}, {:ok, dt} |> DateTime.load |> DateTime.to_string)
          Map.put(s, k, ds)
        _ -> s
      end
    end
  end
end
