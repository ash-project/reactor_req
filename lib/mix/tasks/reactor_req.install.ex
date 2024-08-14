defmodule Mix.Tasks.ReactorReq.Install do
  @moduledoc """
  Installs Reactor.Req into a project.  Should be called with `mix igniter.install reactor_req`.
  """

  alias Igniter.{Mix.Task, Project.Formatter}

  use Task

  @doc false
  @impl Task
  def igniter(igniter, _argv) do
    igniter
    |> Formatter.import_dep(:reactor_req)
  end
end
