defmodule NotesWeb.NotesIndexLive do
  use NotesWeb, :live_view
  alias Notes.Noted.NoteServer
  alias NotesWeb.NotesNewLive
  alias NotesWeb.NotesEditLive
  alias Notes.Noted.Note

  def mount(_params, _session, socket) do
    if connected?(socket), do: Note.subscribe()
    all_notes = NoteServer.all_notes()
    socket = assign(socket, :notes, all_notes)
    socket = assign(socket, :notes_length, Kernel.length(all_notes))
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div class="notes">
        <div class="notes-header">
            <h2 class="notes-title">&#9782; Notes</h2>
            <p class="notes-count"><%= @notes_length %></p>
        </div>
        <div class="notes-list">
          <%= for note <- @notes do %>
            <%= live_patch to: Routes.live_path(@socket, NotesEditLive, note.id) do %>
              <div class="notes-list-item">
                <h3><%= note.title %></h3>
                <p><%= note.body %></p>
              </div>
            <% end %>
          <% end %>
        </div>
        <%= live_patch "+", to: Routes.live_path(@socket, NotesNewLive), class: "floating-button" %>
      </div >
    """
  end

  def handle_event("get-note-detail", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: Routes.live_path(socket, NotesEditLive, id: id))}
  end

  def handle_info({:note_created, note}, socket) do
    socket = update(socket, :notes, fn notes -> [note | notes] end)
    {:noreply, socket}
  end
end
