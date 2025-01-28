defmodule Reactor.Req.Builder do
  @moduledoc "Common builder for all DSL entities"
  import Reactor.Template, only: :macros
  alias Reactor.{Argument, Builder, Req.Step}

  @doc false

  def build(req, fun, reactor) do
    arguments =
      req
      |> Map.from_struct()
      |> Map.drop([:__identifier__, :arguments, :name, :guards])
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> Enum.map(fn
        {name, template} when is_template(template) ->
          %Argument{name: name, source: template}
      end)

    Builder.add_step(reactor, req.name, {Step, fun: fun}, arguments,
      guards: req.guards,
      ref: :step_name
    )
  end
end
