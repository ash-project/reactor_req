# SPDX-FileCopyrightText: 2025 James Harton
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule RunReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url

    req_new :new do
      url input(:url)
      method value("GET")
    end

    req_run :run do
      request result(:new)
      http_errors value(:raise)
    end

    return :run
  end

  setup context do
    port = Enum.random(1000..0xFFFF)
    start_link_supervised!({Support.HttpServer, id: context.test, port: port})

    {:ok, base_url: "http://localhost:#{port}/"}
  end

  test "it successfully performs an HTTP request", %{base_url: base_url} do
    assert {:ok, {_request, response}} = Reactor.run(RunReactor, %{url: base_url <> "file.txt"})

    assert response.status == 200
    assert response.body =~ "Marty"
  end

  test "it can fail when the request fails", %{base_url: base_url} do
    assert {:error, error} = Reactor.run(RunReactor, %{url: base_url <> "no_file.txt"})

    assert Exception.message(error) =~ "The requested URL returned error: 404"
  end
end
