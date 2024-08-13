defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.Merge do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :merge, reactor)
  def verify(_, _), do: :ok
end
