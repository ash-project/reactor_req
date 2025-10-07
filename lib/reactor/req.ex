# SPDX-FileCopyrightText: 2025 James Harton
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req do
  @moduledoc """
  An extension which provides direct support for working with `req` requests
  within Reactor.
  """

  use Spark.Dsl.Extension,
    dsl_patches:
      [
        Reactor.Req.Dsl.Delete,
        Reactor.Req.Dsl.Get,
        Reactor.Req.Dsl.Head,
        Reactor.Req.Dsl.Merge,
        Reactor.Req.Dsl.New,
        Reactor.Req.Dsl.Patch,
        Reactor.Req.Dsl.Post,
        Reactor.Req.Dsl.Put,
        Reactor.Req.Dsl.Request,
        Reactor.Req.Dsl.Run
      ]
      |> Enum.map(
        &%Spark.Dsl.Patch.AddEntity{
          section_path: [:reactor],
          entity: &1.__entity__()
        }
      )
end
