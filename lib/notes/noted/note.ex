defmodule Notes.Noted.Note do
  def subscribe() do
    Phoenix.PubSub.subscribe(Notes.PubSub, "notes")
  end
end
