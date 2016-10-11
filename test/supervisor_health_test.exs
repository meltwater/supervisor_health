defmodule SupervisorHealthTest do
  use ExUnit.Case
  doctest SupervisorHealth

  defmodule TestWorker do
    use GenServer
    def start_link() do
      GenServer.start_link(__MODULE__, :ok, [])
    end
  end

  test "supervisor without children" do
    {:ok, pid} = Supervisor.start_link([], [strategy: :one_for_one])
    result = SupervisorHealth.health(pid)
    assert elem(result, 0) == :error
  end

  test "not started supervisor" do
    result = SupervisorHealth.health(TestWorker)
    assert elem(result, 0) == :error
  end

  test "supervisor with children" do
    children = [Supervisor.Spec.worker(TestWorker, [], [])]
    {:ok, pid} = Supervisor.start_link(children, [strategy: :one_for_one])

    {:ok, health} = SupervisorHealth.health(pid)
    internal = Map.get(health, "internalProcesses")
    assert Map.keys(internal) |> Enum.member?("#{inspect SupervisorHealthTest.TestWorker}")
  end
end
