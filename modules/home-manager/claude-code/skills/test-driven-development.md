---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

Write the test first. Watch it fail. Write minimal code to pass.

**If you didn't watch the test fail, you don't know if it tests the right thing.**

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over. No keeping it as "reference." Delete means delete.

## The Cycle

### RED - Write One Failing Test

One behavior, clear name, real code (no mocks unless unavoidable).

```rust
#[test]
fn retries_failed_operations_3_times() {
    let attempts = std::cell::Cell::new(0);
    let operation = || {
        attempts.set(attempts.get() + 1);
        if attempts.get() < 3 { Err("fail") } else { Ok("success") }
    };

    let result = retry_operation(operation);

    assert_eq!(result.unwrap(), "success");
    assert_eq!(attempts.get(), 3);
}
```

### Verify RED

```bash
just test
```

Confirm: test **fails** (not errors), for the expected reason (feature missing, not typos).

### GREEN - Minimal Code to Pass

```rust
fn retry_operation<T, E>(mut f: impl FnMut() -> Result<T, E>) -> Result<T, E> {
    for i in 0..3 {
        match f() {
            Ok(val) => return Ok(val),
            Err(e) if i == 2 => return Err(e),
            _ => continue,
        }
    }
    unreachable!()
}
```

Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN

```bash
just test
```

Confirm: test passes, other tests still pass, output pristine.

**Test fails?** Fix code, not test. **Other tests fail?** Fix now.

### REFACTOR

After green only: remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior.

### Repeat

Next failing test for next behavior.

## Bug Fix Example

**Bug:** Empty email accepted

**RED:**

```rust
#[test]
fn rejects_empty_email() {
    let result = submit_form(FormData { email: "".into() });
    assert_eq!(result.unwrap_err(), "Email required");
}
```

**Verify RED** - fails because empty email is currently accepted.

**GREEN:**

```rust
fn submit_form(data: FormData) -> Result<(), &'static str> {
    if data.email.trim().is_empty() {
        return Err("Email required");
    }
    // ...
    Ok(())
}
```

**Verify GREEN** - all tests pass.

## Rationalizations (All Mean "Start Over with TDD")

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Already manually tested" | Ad-hoc != systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Unverified code is debt. |
| "Need to explore first" | Fine. Throw away exploration, then TDD. |
| "Test is hard to write" | Hard to test = hard to use. Simplify the design. |
| "TDD will slow me down" | TDD is faster than debugging. |

## Verification Checklist

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass, output pristine
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write wished-for API. Write assertion first. Ask your human partner. |
| Test too complicated | Design too complicated. Simplify interface. |
| Must mock everything | Code too coupled. Use dependency injection. |

## Testing Anti-Patterns

When adding mocks or test utilities, read @testing-anti-patterns.md to avoid common pitfalls:

- Testing mock behavior instead of real behavior
- Adding test-only methods to production types
- Mocking without understanding dependencies
