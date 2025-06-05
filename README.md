<img src="https://github.com/ash-project/reactor/blob/main/logos/reactor-logo-light-small.png?raw=true#gh-light-mode-only" alt="Logo Light" width="250">
<img src="https://github.com/ash-project/reactor/blob/main/logos/reactor-logo-dark-small.png?raw=true#gh-dark-mode-only" alt="Logo Dark" width="250">

# Reactor.Req

[![Build Status](https://github.com/ash-project/reactor_req/actions/workflows/elixir.yml/badge.svg)](https://github.com/ash-project/reactor/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hex version badge](https://img.shields.io/hexpm/v/reactor_req.svg)](https://hex.pm/packages/reactor_req)

A [Reactor](https://github.com/ash-project/reactor) extension that provides steps for working with HTTP requests via [Req](https://github.com/wojtekmach/req).

## Example

The following example uses Reactor to retrieve the repository description from the GitHub API:

```elixir
defmodule GetGitHubRepoDescription do
  use Reactor, extensions: [Reactor.Req]

  input :owner
  input :repo

  step :repo_url do
    argument :owner, input(:owner)
    argument :repo, input(:repo)

    run fn args ->
      URI.new("https://api.github.com/repos/#{args.owner}/#{args.repo}")
    end
  end

  req_get :get_repo do
    url result(:repo_url)
    headers value([accept: "application/vnd.github.v3+json"])
    http_errors value(:raise)
  end

  step :get_description do
    argument :description, result(:get_repo, [:body, "description"])
    run fn args -> {:ok, args.description} end
  end
end

Reactor.run!(GetGitHubRepoDescription, %{
  owner: "ash-project",
  repo: "reactor_req"
})

# => "A Reactor DSL extension for making HTTP requests with Req."
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `reactor_req` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reactor_req, "~> 0.1.3"}
  ]
end
```

Documentation for the latest release is available on [HexDocs](https://hexdocs.pm/reactor_req).

## Licence

This software is licensed under the terms of the MIT License.
See the `LICENSE` file included with this package for the terms.
