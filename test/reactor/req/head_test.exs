# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.HeadTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias Plug.Conn

  defmodule HeadReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url

    req_head :request do
      url input(:url)
      http_errors value(:raise)
    end
  end

  test "it can send a HEAD request", %{test: test} do
    port = Enum.random(1000..0xFFFF)

    start_link_supervised!(
      {Support.HttpServer,
       id: test,
       port: port,
       stub: fn conn ->
         assert conn.method == "HEAD"
         Conn.send_resp(conn, 200, conn.method)
       end}
    )

    assert {:ok, response} = Reactor.run(HeadReactor, %{url: "http://localhost:#{port}/stub"})

    assert response.status == 200
    assert response.body == ""
  end
end
