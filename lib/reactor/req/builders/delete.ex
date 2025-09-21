# SPDX-FileCopyrightText: 2025 James Harton
#
# SPDX-License-Identifier: MIT

defimpl Reactor.Dsl.Build, for: Reactor.Req.Dsl.Delete do
  @moduledoc false
  def build(req, reactor), do: Reactor.Req.Builder.build(req, :delete, reactor)
  def verify(_, _), do: :ok
end
