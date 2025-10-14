# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.Ext do
  @moduledoc false

  # Don't try and use this extension. It's just here to work around a problem
  # with spark.formatter and dsl patches.

  use Spark.Dsl.Extension,
    sections: [
      %Spark.Dsl.Section{
        name: :reactor,
        top_level?: true,
        entities:
          Enum.map(
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
            ],
            & &1.__entity__()
          )
      }
    ]
end
