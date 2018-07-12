defmodule ImportMonitor do
   use GenServer

   ## Client API

   def start do
#      {:ok, val} = :fs.start_link(ImportMonitor, "/ALT/Sisyphus/aarch64/SRPMS.classic/")
#      {:ok, val} = :fs.start_link(ImportMonitor, "/usr/local/home/majioa/git/elixir/import/1")
#      :ok = :fs.subscribe(ImportMonitor)
#      list = :fs.known_events(ImportMonitor)
#      pid = :fs.start_looper()
#      {:ok, pid} = GenServer.start_link(__MODULE__, %{fs: val, pid: pid, list: list})
      {:ok, pid} = :fs_server.start_link(ImportMonitor, &ImportMonitor.hh/2, :inotifywait, "/usr/local/home/majioa/git/elixir/import/1", "./")
   end

   def push(pid, item) do
      GenServer.cast(pid, {:push, item})
   end

   def pop(pid, a) do
      GenServer.call(pid, {:get, a})
      :hello
   end

   def fs(pid) do
      GenServer.call(pid, {:get, :fs})
   end

   # server

   def hh(res, ee) do
      res |> IO.inspect
      ee |> IO.inspect
   end

   @impl true
   def handle_call({:get, key}, _from, state) do
      state |> IO.inspect
      {:reply, Map.get(state, key), state}
   end

   @impl true
   def handle_cast({:push, item}, state) do
      {:noreply, [item | state]}
   end

   def __using__ _ do
   end
end
