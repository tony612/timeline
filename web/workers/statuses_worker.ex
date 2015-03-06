defmodule Timeline.StatusesWorker do
  @user_timeline_url "https://api.twitter.com/1.1/statuses/user_timeline.json"

  alias Timeline.Repo
  alias Timeline.Status
  require Logger
  import Ecto.Query, only: [from: 2]

  def get_statuses do
    case HTTPoison.get @user_timeline_url do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        handle(body)
      {:ok, %HTTPoison.Response{status_code: 429, body: body, headers: headers}} ->
        Logger.debug body, headers
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def handle(body) when is_binary(body) do
    {:ok, statuses} = JSX.decode(body)
    handle(statuses)
  end
  def handle([status|t]) do
    type = "twtter"
    %{"text" => text, "created_at" => posted_at, "id" => source_id} = status
    found = Repo.one(from s in Status, where: s.source_type == ^type and s.source_id == ^source_id)
    if found do
      handle(t)
    else
      record = %Status{text: text, source_type: type, source_id: source_id, posted_at: posted_at}
      Repo.insert record
    end
  end
  def handle([]), do: Logger.info "Done."
end
