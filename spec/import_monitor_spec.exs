defmodule ImportMonitorSpec do
   use ESpec

   let!(:pid) do
      {:ok, pid} = ImportMonitor.start
      pid
   end

   describe "server" do
      it do
         expect ImportMonitor.pop(pid(), :list) |> to(eq :hello)
         :timer.sleep(10000)
      end

      xcontext "#create" do
         it do
            expect ImportMonitor.push(pid, :world) |> to(eq :ok)
         end
      end

      xcontext "#create" do
         before do
            ImportMonitor.push(pid, :world)
         end

         it do
            expect ImportMonitor.pop(pid) |> to(eq :world)
         end
      end
   end
end
