# SPDX-FileCopyrightText: 2025 James Harton
#
# SPDX-License-Identifier: MIT

defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.New do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :new, reactor)
  def verify(_, _), do: :ok
end
