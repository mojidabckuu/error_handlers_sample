defmodule ErrorHandler.Server do
  use GenServer

  @timeout 2_000
  @errors_list_limit 5

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def reset_timer() do
    GenServer.call(__MODULE__, :reset_timer)
  end

  # ErrorHandler.Server.record_error_with_text("oooooppppssss!!!")
  # Enum.map(1..100, fn _ -> ErrorHandler.Server.record_error_with_text("oooooppppssss!!!") end)

  def record_error_with_text(text) do
    GenServer.cast(__MODULE__, {:record_error, text})
  end

  def init(_) do
    Logger.info("Error server has started")
    timer = Process.send_after(self(), :work, @timeout)
    {:ok, %{timer: timer, errors: [], errors_count: 0}}
  end

  def handle_call(:reset_timer, _from, %{timer: timer} = state) do
    Logger.debug("Call reset timer")
    :timer.cancel(timer)
    timer = Process.send_after(self(), :work, @timeout)
    state = %{state | timer: timer}
    {:reply, :ok, state}
  end

  def handle_cast({:record_error, text}, state) do
    Logger.debug("Record an error")
    errors = state.errors
    errors_count = state.errors_count
    errors = errors ++ [%{text: text}]
    state = %{state | errors: errors, errors_count: errors_count + 1}
    state = if errors_count + 1 >= @errors_list_limit do
      persist_errors(state.errors)
      %{state | errors: [], errors_count: 0}
    else
      state
    end
    {:noreply, state}
  end

  def handle_info(:work, state) do
    Logger.debug("Timer tick handler called")
    # Do the work you desire here

    # Start the timer again
    timer = Process.send_after(self(), :work, @timeout)
    persist_errors(state.errors)
    {:noreply, %{timer: timer, errors: [], errors_count: 0}}
  end

  defp persist_errors([]) do
    Logger.debug("Save errors to db but nothing to save")
  end

  defp persist_errors(errors) do
    Logger.debug("Save errors to db")
    ErrorHandler.Repo.insert_all("errors", errors, [])
  end

  # So that unhanded messages don't error
  def handle_info(_, state) do
    {:ok, state}
  end
end
