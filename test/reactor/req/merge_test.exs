defmodule Reactor.Req.MergeTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule MergeReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :url
    input :auth

    req_new :new do
      url input(:url)
    end

    req_merge :merged do
      request result(:new)
      auth input(:auth)
    end

    return :merged
  end

  test "it merges requests together" do
    assert {:ok, req} =
             Reactor.run(MergeReactor, %{
               url: "https://harton.dev/james/reactor_req",
               auth: {:basic, "marty:mcfly"}
             })

    assert req.url == URI.parse("https://harton.dev/james/reactor_req")
    assert req.options.auth == {:basic, "marty:mcfly"}
  end
end
