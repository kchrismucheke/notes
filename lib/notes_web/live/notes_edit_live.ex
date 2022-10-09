defmodule NotesWeb.NotesEditLive do
  alias NotesWeb.NotesIndexLive
  use NotesWeb, :live_view
  alias Notes.Noted.NoteServer

  def mount(%{"id" => id}, _session, socket) do
    note = NoteServer.get_note(String.to_integer(id))
    {:ok, assign(socket, :note, note)}
  end

  def render(assigns) do
    ~L"""
     <div class="note">
         <div class="note-header">
            <h3>
                 <%= live_patch "<", to: Routes.live_path(@socket, NotesIndexLive) %>
            </h3>
            <button type="submit" form="create-note-form">Done</button>
            <button phx-click="delete_note">Delete</button>
          </div>

          <form id="create-note-form" phx-change="detect_change" phx-submit="save_note">
             <input type="text" placeholder="Add Title" value="<%= @note.title %>" name="title"/>
              <br>
              <br>
              <textarea placeholder="Add note" name="body"><%= @note.body %></textarea>
          </form>
       </div >
    """
  end

  def handle_event("delete_note", _value, socket) do
    NoteServer.delete_note(socket.assigns.note.id)

    {:noreply,
     socket
     |> redirect(to: "/")}
  end

  def handle_event("save_note", _value, socket) do
    NoteServer.update_note(socket.assigns.note)

    {:noreply,
     socket
     |> redirect(to: "/")}
  end
end
