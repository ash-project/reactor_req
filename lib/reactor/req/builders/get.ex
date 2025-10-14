# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.Get do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :get, reactor)
  def verify(_, _), do: :ok
end
