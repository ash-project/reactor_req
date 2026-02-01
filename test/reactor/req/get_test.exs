# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.GetTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule GetReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url

    req_get :request do
      url input(:url)
      http_errors value(:raise)
    end
  end

  setup context do
    port = Enum.random(1000..0xFFFF)
    start_link_supervised!({Support.HttpServer, id: context.test, port: port})

    {:ok, base_url: "http://localhost:#{port}/"}
  end

  test "it successfully performs an HTTP request", %{base_url: base_url} do
    assert {:ok, response} = Reactor.run(GetReactor, %{url: base_url <> "file.txt"})

    assert response.status == 200
    assert response.body =~ "Marty"
  end

  test "it can fail when the request fails", %{base_url: base_url} do
    assert {:error, error} = Reactor.run(GetReactor, %{url: base_url <> "no_file.txt"})

    assert Exception.message(error) =~ "The requested URL returned error: 404"
  end
end
