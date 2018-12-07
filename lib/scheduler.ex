defmodule StatWatch.Scheduler do
  use GenServer

  #api
  def start_link, do: GenServer.start_link(__MODULE__, [])

  #server
  def init(state) do
    handle_info(:work, state)
    {:ok, state}
  end

  def handle_info(:work, state) do
    StatWatch.update_stats()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, hours(1))
  end

  defp hours(n), do: 1000 * 60 * 60 * n
end