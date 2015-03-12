defmodule Timeline.StatusesController do
  use Timeline.Web, :controller

  plug :action

  import Ecto.Query, only: [from: 2]

  alias Timeline.Status
  alias Timeline.Repo

  def index(conn, params) do
    statuses = (from s in Status, select: s) |> paginate(params["page"], params["size"]) |> Repo.all
    results = Enum.map statuses, fn(s) -> Status.jsonable(s) end

    json conn, results
  end

  def paginate(query, page \\ 1, size \\ 20) do
    page = page || 1
    size = size || 20
    from query,
      limit: ^size,
      offset: ^((page - 1) * size)
  end
end
