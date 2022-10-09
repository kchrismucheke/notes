defmodule NotesWeb.PageController do
  use NotesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
