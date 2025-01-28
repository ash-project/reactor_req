defmodule Reactor.Req.Dsl.Options do
  @moduledoc """
  All the known options of Req (as of this writing).
  """

  alias Reactor.Template

  @options [
    adapter: "Adapter to use to make the actual HTTP request",
    auth: "Sets request authentication",
    aws_sigv4: "If set, the AWS options to sign request",
    base_url: "If set, the request URL is prepended with this base URL",
    body: "The request body",
    cache_dir: "The directory to store the cache",
    cache: "If `true`, performs HTTP caching",
    compress_body: "If set to `true`, compresses the request body using gzip",
    connect_options:
      "Dynamically starts (or re-uses already started) Finch pool with the given connection options",
    decode_body: "If set to `false`, disables automatic response body decoding",
    decode_json: "Options to pass to `Jason.decode!/2`",
    finch_private: "A map or keyword list of private metadata to add to the Finch request",
    finch_request:
      "A function that executes the Finch request, defaults to using `Finch.request/3`",
    finch: "The Finch pool to use. Defaults to pool automatically started by `Req`",
    form_multipart: "If set, encodes the request body as `multipart/form-data`",
    form: "If set, encodes the request body as `application/x-www-form-urlencoded`",
    headers: "The request headers as a `{key, value}` enumerable (e.g. map, keyword list)",
    http_errors: "How to manage 4xx and 5xx responses",
    inet6: "If set to `true`, uses IPv6",
    into: "Where to send the response body",
    json: "If set, encodes the request body as JSON",
    max_redirects: "The maximum number of redirects, defaults to `10`",
    max_retries:
      "Maximum number of retry attempts, defaults to `3` (for a total of `4` requests to the server, including the initial one)",
    method: "The request method, defaults to `:get`",
    params: "If set, appends parameters to the request query string (via `put_params` step)",
    path_params_style: "How path params are expressed (via `put_path_params` step)",
    path_params: "If set, uses a templated request path (via `put_path_params` step)",
    plug:
      "If set, calls the given plug instead of making an HTTP request over the network (via `run_plug` step)",
    pool_timeout: "Pool checkout timeout in milliseconds, defaults to `5000`",
    raw:
      "If set to `true`, disables automatic body decompression (`decompress_body` step) and decoding (`decode_body` step)",
    receive_timeout: "Socket receive timeout in milliseconds, defaults to `15_000`",
    redirect_trusted:
      "By default, authorization credentials are only sent on redirects with the same host, scheme and port. If `:redirect_trusted` is set to `true`, credentials will be sent to any host",
    redirect: "If set to `false`, disables automatic response redirects",
    request: "A previously built request",
    retry_delay:
      "If not set, which is the default, the retry delay is determined by the value of retry-delay header on HTTP 429/503 responses. If the header is not set, the default delay follows a simple exponential backoff: 1s, 2s, 4s, 8s, ...",
    retry_log_level:
      "The log level to emit retry logs at. Can also be set to `false` to disable logging these messages. Defaults to `:warning`",
    retry: "One of `:safe_transient` (default), `:transient`, `fun` or `false`",
    unix_socket: "If set, connect through the given UNIX domain socket",
    url: "The request URL"
  ]

  @type entity :: %{
          __identifier__: any,
          adapter: nil | Template.t(),
          auth: nil | Template.t(),
          aws_sigv4: nil | Template.t(),
          base_url: nil | Template.t(),
          body: nil | Template.t(),
          cache_dir: nil | Template.t(),
          cache: nil | Template.t(),
          compress_body: Template.t(),
          compressed: nil | Template.t(),
          connect_options: nil | Template.t(),
          decode_body: nil | Template.t(),
          decode_json: nil | Template.t(),
          finch_private: nil | Template.t(),
          finch_request: nil | Template.t(),
          finch: nil | Template.t(),
          form_multipart: nil | Template.t(),
          form: nil | Template.t(),
          guards: [Reactor.Guard.Build.t()],
          headers: nil | Template.t(),
          http_errors: nil | Template.t(),
          inet6: nil | Template.t(),
          into: nil | Template.t(),
          json: nil | Template.t(),
          max_redirects: nil | Template.t(),
          max_retries: nil | Template.t(),
          method: nil | Template.t(),
          name: atom,
          params: nil | Template.t(),
          path_param_style: nil | Template.t(),
          plug: nil | Template.t(),
          pool_timeout: nil | Template.t(),
          raw: nil | Template.t(),
          receive_timeout: nil | Template.t(),
          redirect_trusted: nil | Template.t(),
          redirect: nil | Template.t(),
          retry_delay: nil | Template.t(),
          retry_log_level: nil | Template.t(),
          retry: nil | Template.t(),
          struct: module,
          unix_socket: nil | Template.t(),
          url: nil | Template.t()
        }

  @doc "Merge options"
  @spec merge(Keyword.t()) :: Keyword.t()
  def merge(overrides) do
    @options
    |> Enum.map(fn {name, doc} ->
      {name,
       [
         type: {:or, [nil, Template.type()]},
         required: false,
         doc: doc
       ]}
    end)
    |> Keyword.merge(overrides)
  end

  @doc "Struct attributes"
  def struct_attrs do
    @options
    |> Keyword.keys()
    |> Enum.map(&{&1, nil})
    |> Keyword.put(:__identifier__, nil)
    |> Keyword.put(:arguments, [])
    |> Keyword.put(:name, nil)
    |> Keyword.put(:guards, [])
  end
end
