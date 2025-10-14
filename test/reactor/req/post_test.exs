# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.PostTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias Plug.Conn

  defmodule PostReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url
    input :skip?

    req_post :request do
      argument :skip?, input(:skip?)
      url input(:url)
      http_errors value(:raise)

      guard fn %{skip?: skip}, _context ->
        if skip do
          {:halt, {:ok, nil}}
        else
          :cont
        end
      end
    end
  end

  test "it can send a POST request", %{test: test} do
    port = Enum.random(1000..0xFFFF)

    start_link_supervised!(
      {Support.HttpServer,
       id: test,
       port: port,
       stub: fn conn ->
         Conn.send_resp(conn, 200, conn.method)
       end}
    )

    assert {:ok, response} =
             Reactor.run(PostReactor, %{url: "http://localhost:#{port}/stub", skip?: false})

    assert response.status == 200
    assert response.body == "POST"
  end

  test "it can take arguments", %{test: test} do
    assert {:ok, nil} =
             Reactor.run(PostReactor, %{url: "http://localhost:1337/stub", skip?: true})
  end
end
