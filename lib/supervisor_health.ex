defmodule SupervisorHealth do
  @moduledoc """
  Deals with health diagnostics
  """

  require Logger

  @doc """
  Returns internal health information
  If something is wrong {:error, info} is returned, otherwise
  {:ok, info}
  """
  def health(app_supervisor) do
    internal_info = health_vectors(app_supervisor)
    result = if internal_info == :error, do: :error, else: :ok
    summary = %{"health" => result,
      "internalProcesses" => internal_info}

    {result, summary}
  end

  # Lists some internal process information, can error if
  # Supervisor is not started for example.
  defp health_vectors(app_supervisor) do
    try do
      app_supervisor
      |> Supervisor.which_children()
      |> Enum.map(fn({module, pid, _, _}) ->
        info = Process.info(pid, [:current_function,
                                  :status,
                                  :stack_size,
                                  :reductions])
        status = %{"current_function" => info
                   |> Keyword.get(:current_function)
                   |> Tuple.to_list,
          "status" => Keyword.get(info, :status),
          "stack_size" => Keyword.get(info, :stack_size),
          "reductions" => Keyword.get(info, :reductions)}
        Map.put(%{}, "#{inspect module}", status)
      end)
      |> Enum.reduce(fn(m1, m2) -> Map.merge(m1, m2) end)
    catch
      _,error ->
        Logger.error("Error when getting internal process information: " <>
          "#{inspect error}")
      :error
    end
  end
end
