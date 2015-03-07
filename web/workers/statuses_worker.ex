defmodule Timeline.StatusesWorker do
  alias Timeline.Repo
  alias Timeline.Status
  require Logger
  import Ecto.Query, only: [from: 2]

  alias OAuth2.Strategy.ClientCredentials

  defstruct user_id: nil

  def get_statuses(user_id) do
    struct(__MODULE__, [user_id: user_id])
    strategy = ClientCredentials.new(
      client_id:  config[:client_id],
      client_secret: config[:client_secret],
      site: "https://api.twitter.com",
      token_url: "/oauth2/token"
    )
    token = ClientCredentials.get_token!(strategy)
    case OAuth2.AccessToken.get(token, "/1.1/statuses/user_timeline.json?screen_name=#{user_id}") do
      {:ok, statuses} ->
        handle(statuses)
      {:error, error} ->
        Logger.info error
    end
  end

  def handle([status|t]) do
    type = "twtter"
    %{"text" => text, "created_at" => posted_at, "id_str" => source_id} = status
    found = Repo.one(from s in Status, where: s.source_type == ^type and s.source_id == ^source_id)
    if found do
      handle(t)
    else
      record = %Status{text: text, source_type: type, source_id: source_id, posted_at: posted_at}
      Repo.insert record
    end
  end
  def handle([]), do: Logger.info "Done with #{@user_id}"
  def handle(_), do: Logger.error "Error with #{@user_id}"

  defp config do
    Application.get_env(:timeline, Timeline.StatusesWorker)
  end
end
