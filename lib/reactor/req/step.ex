defmodule Reactor.Req.Step do
  @moduledoc """
  A step which delegates to `req`.
  """

  use Reactor.Step

  alias Reactor.Req.Dsl.Options

  @doc false
  @impl true
  @spec run(Reactor.inputs(), Reactor.context(), keyword) :: {:ok | :error, any}
  def run(arguments, _context, options) do
    fun =
      Keyword.fetch!(options, :fun)

    req_options = Options.struct_attrs() |> Keyword.keys()

    arguments =
      arguments
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> Enum.filter(fn {key, _value} -> key in req_options end)

    do_run(arguments, fun)
  end

  defp do_run(arguments, :delete) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.delete(request, options)
    else
      Req.delete(options)
    end
  end

  defp do_run(arguments, :get) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.get(request, options)
    else
      Req.get(options)
    end
  end

  defp do_run(arguments, :head) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.head(request, options)
    else
      Req.head(options)
    end
  end

  defp do_run(arguments, :merge) do
    {request, options} = Keyword.pop(arguments, :request)
    {:ok, Req.merge(request, options)}
  end

  defp do_run(arguments, :new) do
    options = Keyword.delete(arguments, :request)
    {:ok, Req.new(options)}
  end

  defp do_run(arguments, :patch) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.patch(request, options)
    else
      Req.patch(options)
    end
  end

  defp do_run(arguments, :post) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.post(request, options)
    else
      Req.post(options)
    end
  end

  defp do_run(arguments, :put) do
    {request, options} = Keyword.pop(arguments, :request)

    if request do
      Req.put(request, options)
    else
      Req.put(options)
    end
  end

  defp do_run(arguments, :request) do
    {request, options} = Keyword.pop(arguments, :request)
    Req.request(request, options)
  end

  defp do_run(arguments, :run) do
    {request, options} = Keyword.pop(arguments, :request)
    {:ok, Req.run(request, options)}
  end
end
