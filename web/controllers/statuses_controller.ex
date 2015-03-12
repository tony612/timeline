defmodule Timeline.StatusesController do
  use Timeline.Web, :controller

  plug :action

  import Ecto.Query, only: [from: 2]

  alias Timeline.Status
  alias Timeline.Repo

  def index(conn, _params) do
    statuses = (from s in Status, select: s) |> Repo.all
    results = Enum.map statuses, fn(s) -> Status.jsonable(s) end

    json conn, results
  end
end
