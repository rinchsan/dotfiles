---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---
# Go Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Go specific content.

## Functional Options

```go
type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) { s.port = port }
}

func NewServer(opts ...Option) *Server {
    s := &Server{port: 8080}
    for _, opt := range opts {
        opt(s)
    }
    return s
}
```

## Small Interfaces

Define interfaces where they are used, not where they are implemented.

## Dependency Injection

Use constructor functions to inject dependencies:

```go
func NewUserService(repo UserRepository, logger Logger) *UserService {
    return &UserService{repo: repo, logger: logger}
}
```

## Error Type Assertions (Go 1.26+)

Prefer `errors.AsType[T]()` over `errors.As()` for type-safe, allocation-free error unwrapping:

```go
var pathErr *fs.PathError
if pathErr, ok := errors.AsType[*fs.PathError](err); ok {
    // use pathErr
}
```

## JSON Encoding (Go 1.27+)

Use `encoding/json/v2` for new code — it rejects invalid UTF-8 and duplicate object names by default, and unmarshals significantly faster than `encoding/json`:

```go
import "encoding/json/v2"

data, err := json.Marshal(v)
err = json.Unmarshal(data, &v)
```

For streaming or token-level control, use `encoding/json/jsontext` instead of hand-rolling a state machine.

## UUIDs (Go 1.27+)

Use the standard library `uuid` package instead of third-party modules (e.g. `google/uuid`) in new code. Existing dependencies on third-party UUID packages do not need to be migrated proactively.

## Reference

See skill: `golang-patterns` for comprehensive Go patterns including concurrency, error handling, and package organization.
