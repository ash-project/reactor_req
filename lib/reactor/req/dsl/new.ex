defmodule Reactor.Req.Dsl.New do
  @moduledoc """
  The `req_new` DSL entity for the `Reactor.Req` DSL extension.
  """

  alias Reactor.Dsl.{Argument, Guard, WaitFor, Where}
  alias Reactor.Req.Dsl.Options

  defstruct Options.struct_attrs() |> Keyword.delete(:request)
  @type t :: Options.entity()

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :req_new,
      describe: """
      Creates a new request using `Req.new/1`

      Note that Reactor doesn't validate any options - it simply passes them to the underlying `Req` function and assumes it will validate them.
      """,
      target: __MODULE__,
      identifier: :name,
      imports: [Argument],
      args: [:name],
      recursive_as: :steps,
      entities: [
        arguments: [WaitFor.__entity__()],
        guards: [Guard.__entity__(), Where.__entity__()]
      ],
      schema:
        Options.merge(
          name: [
            type: :atom,
            required: true,
            doc:
              "A unique name for the step. Used when choosing the return value of the Reactor and for arguments into other steps"
          ]
        )
    }
end
