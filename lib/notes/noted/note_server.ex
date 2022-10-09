defmodule Notes.Noted.NoteServer do
  # alias Notes.Noted.Note
  use GenServer

  # Client
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def all_notes(pid) do
    GenServer.call(__MODULE__, :all_notes)
  end

  def create_note(pid, note) do
    GenServer.cast(__MODULE__, {:create_note, note})
  end

  def get_note(pid, id) do
    GenServer.call(__MODULE__, {:get_note, id})
  end

  def delete_note(pid, id) do
    GenServer.cast(__MODULE__, {:delete_note, id})
  end

  def update_note(pid, note) do
    GenServer.cast(__MODULE__, {:update_note, note})
  end

  # Server
  @impl true
  def init(notes) do
    {:ok, notes}
  end

  @impl true
  def handle_cast({:create_note, note}, notes) do
    updated_note = add_id(notes, note)
    updates_notes = [updated_note | notes]
    {:noreply, updates_notes}
  end

  @impl true
  def handle_cast({:delete_note, id}, notes) do
    updated_notes = notes |> Enum.reject(fn note -> Map.get(note, :id) == id end)
    {:noreply, updated_notes}
  end

  @impl true
  def handle_cast({:update_note, note}, notes) do
    updated_notes = update_in(notes, [Access.filter(&(&1.id == note.id))], fn _ -> note end)
    {:noreply, updated_notes}
  end

  @impl true
  def handle_call({:get_note, id}, _from, notes) do
    found_note = notes |> Enum.filter(fn note -> Map.get(note, :id) == id end) |> List.first()
    {:reply, found_note, notes}
  end

  @impl true
  def handle_call(:all_notes, _from, notes) do
    {:reply, notes, notes}
  end

  defp add_id(notes, note) do
    id = (notes |> Kernel.length()) + 1
    %{note | id: id}
  end
end
