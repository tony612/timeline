defmodule Timeline.PostsController do
  use Timeline.Web, :controller

  plug :action

  def index(conn, _params) do
    json conn, %{hello: "world"}
  end
end
