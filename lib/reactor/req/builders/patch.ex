defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.Patch do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :patch, reactor)
  def verify(_, _), do: :ok
end
