defmodule Timeline.StatusesWorker do
  alias Timeline.Repo
  alias Timeline.Status
  require Logger
  import Ecto.Query, only: [from: 2]

  alias OAuth2.Strategy.ClientCredentials

  defstruct user_id: nil

  def get_statuses(user_id, max_id \\ nil) do
    struct(__MODULE__, [user_id: user_id])
    strategy = ClientCredentials.new(
      client_id:  config[:client_id],
      client_secret: config[:client_secret],
      site: "https://api.twitter.com",
      token_url: "/oauth2/token"
    )
    token = ClientCredentials.get_token!(strategy)
    params = [screen_name: user_id, count: 200]
    if max_id do
      params = Dict.put(params, :max_id, max_id)
    end
    params_str = Enum.map_join(params, "&", fn {k ,v} -> "#{k}=#{v}" end)
    case OAuth2.AccessToken.get(token, "/1.1/statuses/user_timeline.json?#{params_str}") do
      {:ok, statuses} ->
        next_max_id = handle(statuses)
        if max_id != next_max_id do
          get_statuses(user_id, next_max_id)
        else
          Logger.info "Done"
        end
      {:error, error} ->
        Logger.info error
    end
  end

  def handle([status|t]) do
    type = "twtter"
    %{"text" => text, "created_at" => posted_at, "id_str" => source_id} = status
    found = Repo.one(from s in Status, where: s.source_type == ^type and s.source_id == ^source_id)
    unless found do
      # {:ok, parsed_posted_at} = parse_datetime(posted_at)
      record = %Status{text: text, source_type: type, source_id: source_id, posted_at: parse_datetime(posted_at)}
      Repo.insert record
    end
    # For returning max_id
    if t == [] do
      Logger.info "Done by #{source_id}"
      source_id
    else
      handle(t)
    end
  end
  def handle(_), do: Logger.error "Error with #{@user_id}"

  defp config do
    Application.get_env(:timeline, Timeline.StatusesWorker)
  end

  # "Sat Mar 07 15:13:09 +0000 2015"
  def parse_datetime(date_str) do
    {:ok, dt} = date_str
      |> Timex.DateFormat.parse!("%a %b %d %H:%M:%S %z %Y", :strftime)
      |> Timex.DateFormat.format!("{ISOz}")
      |> Ecto.DateTime.cast
    {:ok, dumped} = Ecto.DateTime.dump(dt)
    dumped
  end
end
