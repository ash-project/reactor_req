defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.Put do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :put, reactor)
  def verify(_, _), do: :ok
end
