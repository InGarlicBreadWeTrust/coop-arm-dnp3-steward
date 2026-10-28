# Build fix: CountingSOEHandler.h missing <stdexcept>

Symptom: on modern glibc (>= 2.33, Ubuntu 22.04+), the integration test
`cpp/tests/integration/mocks/CountingSOEHandler.h` fails to compile because
`std::out_of_range` is used without including `<stdexcept>`.

Root cause: the file previously relied on transitive includes from `<vector>`
or `<map>`, which no longer provide `std::out_of_range` on modern
libstdc++-v3. The fix is the canonical C11/C++17 fix: add the header.

Diff:
```diff
--- a/cpp/tests/integration/mocks/CountingSOEHandler.h
+++ b/cpp/tests/integration/mocks/CountingSOEHandler.h
@@ -5,6 +5,7 @@
 #include <string>
 #include <vector>
 #include <stdexcept>
```

Statuses affected by this bug:
- `DNP3_TESTS=ON` on a modern Linux host (e.g., any CI image from 2023 onward)
- Any deployment using the integration test suite

Note: this is a fix, not a behaviour change. The integration test
still runs exactly the same scenario; it just compiles again.
