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

## Cryptographic Randomness

As of Go 1.26, `crypto/{rand,rsa,ecdsa,ecdh,ed25519,dsa}` no longer honor a caller-supplied random source — they always use a secure source. As of Go 1.27, `crypto/tls.Config.Rand` is likewise deprecated. For deterministic randomness in tests, use `testing/cryptotest.SetGlobalRandom()` instead of a custom source.

`crypto/rsa` PKCS #1 v1.5 encryption padding is deprecated (Go 1.26+) — do not use it in new code; prefer OAEP (`EncryptOAEPWithOptions`).

## Post-Quantum Signatures (Go 1.27+)

Use `crypto/mldsa` (ML-DSA, FIPS 204) where post-quantum signature resistance is required. `crypto/x509` and `crypto/tls` support ML-DSA keys and TLS 1.3 signature schemes (`MLDSA44`, `MLDSA65`, `MLDSA87`) natively.
