<!--
SPDX-FileCopyrightText: 2025 James Harton, Zach Daniel and Rodolfo Torres

SPDX-License-Identifier: MIT
-->

# Reactor.Req Usage Rules for AI Coding Agents

This document provides essential guidelines for AI coding agents when working with the Reactor.Req library.

## Core Concepts

### Extension Setup
- Always add `extensions: [Reactor.Req]` to the Reactor module's `use` statement
- The extension provides HTTP request steps that integrate with Reactor's workflow system

### Step Types Available

The library provides these HTTP method steps:
- `req_get` - GET requests
- `req_post` - POST requests  
- `req_put` - PUT requests
- `req_patch` - PATCH requests
- `req_delete` - DELETE requests
- `req_head` - HEAD requests

And these request building steps:
- `req_new` - Create new request with base options
- `req_merge` - Merge options into existing request
- `req_request` - Generic request with any HTTP method
- `req_run` - Execute a pre-built request

## Common Patterns

### Basic HTTP Request
```elixir
req_get :fetch_data do
  url value("https://api.example.com/data")
  headers value([accept: "application/json"])
end
```

### Using Dynamic Values
- Use `input(:name)` for Reactor inputs
- Use `result(:step_name)` for outputs from other steps
- Use `argument(:name)` for step arguments
- Use `value(literal)` for static values
- Use `template("string/{param}")` for URL templates with `path_params`

### Request Chaining
```elixir
req_get :get_user do
  url template("https://api.github.com/users/{username}")
  path_params value(%{username: input(:username)})
end

req_get :get_repos do
  url result(:get_user, [:body, "repos_url"])
end
```

## Essential Options

### Authentication
- Basic: `auth value({:basic, "user:pass"})`
- Bearer: `auth value({:bearer, "token"})`

### Request Bodies
- JSON: `json value(%{key: "value"})`
- Form: `form value([key: "value"])`
- Multipart: `form_multipart value([file: {:file, "path"}])`
- Raw: `body value("raw data")`

### Error Handling
- `http_errors value(:raise)` - Raise on 4xx/5xx (recommended for most cases)
- `http_errors value(:return)` - Return error responses as-is

### Reliability
- `max_retries value(3)` - Number of retry attempts
- `retry_delay value(1000)` - Delay between retries in ms
- `receive_timeout value(30_000)` - Socket timeout in ms

## Important Guidelines

### URL Construction
- For static URLs: `url value("https://api.example.com/endpoint")`
- For dynamic URLs: `url result(:build_url_step)`
- For templated URLs: `url template("https://api.example.com/{id}")` with `path_params value(%{id: 123})`

### Headers
- Always specify `accept` header for APIs: `headers value([accept: "application/json"])`
- For JSON requests: `headers value([content_type: "application/json"])`
- For authentication: Include in `headers` or use dedicated `auth` option

### Response Access
- Full response: `result(:step_name)`
- Response body: `result(:step_name, [:body])`
- Nested JSON: `result(:step_name, [:body, "field", "nested"])`
- Status code: `result(:step_name, [:status])`

### Error Prevention
- Always handle authentication properly - never hardcode tokens
- Use `http_errors value(:raise)` unless you specifically need to handle error responses
- Set appropriate timeouts for external APIs
- Use retries for transient failures

### Testing
- Use the `plug` option for mocking: `plug value(mock_function)`
- Test both success and failure scenarios

## Best Practices

### Request Building
1. Create base requests with `req_new` for shared configuration
2. Use `req_merge` to add endpoint-specific options
3. Execute with appropriate HTTP method step

### Error Recovery
```elixir
req_get :primary_api do
  url value("https://primary.example.com/data")
  http_errors value(:return)
end

req_get :fallback_api do
  url value("https://backup.example.com/data")
  where result(:primary_api, fn resp -> resp.status >= 400 end)
end
```

### Conditional Execution
Use `where` clauses to conditionally execute requests based on previous results.

### Performance
- Use connection pooling with `finch` option for high-volume scenarios
- Enable caching with `cache value(true)` for cacheable endpoints
- Use streaming with `into` option for large responses

## Common Mistakes to Avoid

1. **Forgetting the extension**: Always include `extensions: [Reactor.Req]`
2. **Hardcoding secrets**: Use inputs or environment variables for tokens
3. **Not handling errors**: Always specify `http_errors` behaviour
4. **Missing content-type**: Specify headers for POST/PUT/PATCH requests
5. **Blocking on failures**: Use appropriate error handling strategies
6. **Incorrect template usage**: Use `value()`, `input()`, `result()`, or `element()` template functions only
7. **Ignoring timeouts**: Set reasonable `receive_timeout` values

## Integration Notes

### With Reactor Patterns
- Use `depends_on` for explicit step dependencies
- Use `where` clauses for conditional execution
- Access nested response data with path notation: `[:body, "field"]`

### With External APIs
- Always include appropriate `User-Agent` headers
- Respect rate limits with retry configuration
- Use authentication headers consistently
- Handle pagination in separate steps if needed

### Testing Integration
- Mock external calls using `plug` option
- Test error scenarios explicitly
- Verify request details in tests (headers, body, etc.)