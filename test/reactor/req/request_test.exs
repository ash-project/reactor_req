# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.RequestTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule RequestReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url

    req_new :new do
      url input(:url)
    end

    req_request :merged do
      request result(:new)
    end
  end

  setup context do
    port = Enum.random(1000..0xFFFF)
    start_link_supervised!({Support.HttpServer, id: context.test, port: port})

    {:ok, base_url: "http://localhost:#{port}/"}
  end

  test "it executes requests", %{base_url: base_url} do
    assert {:ok, response} = Reactor.run(RequestReactor, %{url: base_url <> "file.txt"})

    assert response.status == 200
    assert response.body =~ "Marty"
  end
end
