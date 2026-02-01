# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.PutTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias Plug.Conn

  defmodule PutReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url

    req_put :request do
      url input(:url)
      http_errors value(:raise)
    end
  end

  test "it can send a PUT request", %{test: test} do
    port = Enum.random(1000..0xFFFF)

    start_link_supervised!(
      {Support.HttpServer,
       id: test,
       port: port,
       stub: fn conn ->
         Conn.send_resp(conn, 200, conn.method)
       end}
    )

    assert {:ok, response} = Reactor.run(PutReactor, %{url: "http://localhost:#{port}/stub"})

    assert response.status == 200
    assert response.body == "PUT"
  end
end
