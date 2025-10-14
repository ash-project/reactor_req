# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Reactor.Req.Dsl.NewTest do
  @moduledoc false
  use ExUnit.Case, async: true

  @options [
    adapter: Req.Request,
    auth: {:basic, "marty:outatime"},
    aws_sigv4: [region: "hill-valley"],
    base_url: "http://github.com/ash-project/reactor_req",
    body: "Roads. Where we're going we don't need roads",
    cache_dir: "priv/cache",
    cache: true,
    compress_body: true,
    connect_options: [speed: "88mph"],
    decode_body: false,
    decode_json: [quickly: true],
    finch_private: [calvin: :klein],
    finch_request: &Finch.request/3,
    finch: :swimming_pool,
    form_multipart: true,
    form: true,
    headers: Macro.escape(%{"speed" => ["88mph"]}),
    inet6: true,
    into: [],
    json: true,
    max_redirects: 10,
    max_retries: 10,
    method: :get,
    params: [name: "marty", year: "1985"],
    path_params_style: :colon,
    path_params: [name: "marty"],
    plug: Plug,
    pool_timeout: 15_000,
    raw: true,
    receive_timeout: 15_000,
    redirect_trusted: true,
    redirect: false,
    retry_delay: 10_000,
    retry_log_level: :warn,
    retry: false,
    unix_socket: "priv/pretend.sock",
    url: Macro.escape(URI.new!("https://github.com/ash-project/reactor_req"))
  ]

  defmodule AllOptionsReactor do
    @moduledoc false
    use Reactor, extensions: [Reactor.Req]

    input :adapter
    input :auth
    input :aws_sigv4
    input :base_url
    input :body
    input :cache_dir
    input :cache
    input :compress_body
    input :connect_options
    input :decode_body
    input :decode_json
    input :finch_private
    input :finch_request
    input :finch
    input :form_multipart
    input :form
    input :headers
    input :inet6
    input :into
    input :json
    input :max_redirects
    input :max_retries
    input :method
    input :params
    input :path_params_style
    input :path_params
    input :plug
    input :pool_timeout
    input :raw
    input :receive_timeout
    input :redirect_trusted
    input :redirect
    input :retry_delay
    input :retry_log_level
    input :retry
    input :unix_socket
    input :url

    req_new :new do
      adapter input(:adapter)
      auth input(:auth)
      aws_sigv4 input(:aws_sigv4)
      base_url input(:base_url)
      body input(:body)
      cache_dir input(:cache_dir)
      cache input(:cache)
      compress_body input(:compress_body)
      connect_options input(:connect_options)
      decode_body input(:decode_body)
      decode_json input(:decode_json)
      finch_private input(:finch_private)
      finch_request input(:finch_request)
      finch input(:finch)
      form_multipart input(:form_multipart)
      form input(:form)
      headers input(:headers)
      inet6 input(:inet6)
      into input(:into)
      json input(:json)
      max_redirects input(:max_redirects)
      max_retries input(:max_retries)
      method input(:method)
      params input(:params)
      path_params_style input(:path_params_style)
      path_params input(:path_params)
      plug input(:plug)
      pool_timeout input(:pool_timeout)
      raw input(:raw)
      receive_timeout input(:receive_timeout)
      redirect_trusted input(:redirect_trusted)
      redirect input(:redirect)
      retry_delay input(:retry_delay)
      retry_log_level input(:retry_log_level)
      retry input(:retry)
      unix_socket input(:unix_socket)
      url input(:url)
    end
  end

  for {key, value} <- @options do
    test "it passes the `#{inspect(key)}` option" do
      inputs =
        @options
        |> Map.new(fn {k, _} -> {k, nil} end)
        |> Map.put(unquote(key), unquote(value))

      assert req = Reactor.run!(AllOptionsReactor, inputs)

      if Map.has_key?(req, unquote(key)) do
        assert req.unquote(key) == unquote(value)
      else
        assert req.options.unquote(key) == unquote(value)
      end
    end
  end
end
