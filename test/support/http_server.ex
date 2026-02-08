# SPDX-FileCopyrightText: 2024 reactor_req contributors <https://github.com/ash-project/reactor_req/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule Support.HttpServer do
  @moduledoc false
  use Plug.Builder, init_mode: :runtime, copy_opts_to_assign: :opts

  plug Plug.Static,
    at: "/",
    from: Path.expand("#{__DIR__}/../fixtures")

  plug :maybe_stub

  def maybe_stub(conn, _opts) when conn.path_info == ["stub"] do
    stub = conn.assigns.opts[:stub]

    if stub do
      stub.(conn)
    else
      send_resp(conn, 500, "No, we don't want no stubs")
    end
  end

  def maybe_stub(conn, _opts) do
    send_resp(conn, 404, "Not found")
  end

  @doc false
  def start_link(opts \\ []) do
    {stub, opts} = Keyword.pop(opts, :stub)

    [plug: {__MODULE__, stub: stub}, scheme: :http, startup_log: false]
    |> Keyword.merge(opts)
    |> Bandit.start_link()
  end

  @doc false
  def child_spec(opts) do
    {id, opts} = Keyword.pop(opts, :id, __MODULE__)

    %{
      id: id,
      start: {__MODULE__, :start_link, [opts]}
    }
  end
end
