---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---
# Go Security

> This file extends [common/security.md](../common/security.md) with Go specific content.

## Secret Management

```go
apiKey := os.Getenv("OPENAI_API_KEY")
if apiKey == "" {
    log.Fatal("OPENAI_API_KEY not configured")
}
```

## Security Scanning

- Use **gosec** for static security analysis:
  ```bash
  gosec ./...
  ```

## Context & Timeouts

Always use `context.Context` for timeout control:

```go
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()
```

## Post-Quantum Signatures (Go 1.27+)

Use `crypto/mldsa` (ML-DSA, FIPS 204) where post-quantum signature resistance is required. `crypto/x509` and `crypto/tls` support ML-DSA keys and TLS 1.3 signature schemes (`MLDSA44`, `MLDSA65`, `MLDSA87`) natively.

## Deterministic Randomness in Tests

`crypto/tls.Config.Rand` is deprecated as of Go 1.27. Use `testing/cryptotest.SetGlobalRandom` for deterministic randomness in tests instead.
