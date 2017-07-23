TEST_BUNDLE_PATH ?= .build/debug/CouchbasePackageTests.xctest/Contents/MacOS/CouchbasePackageTests

build:
	swift build

test:
	swift test

cover:
	swift test -Xswiftc -profile-generate -Xswiftc -profile-coverage-mapping
	xcrun llvm-profdata merge -o testprof.profdata default.profraw
	xcrun llvm-cov report -instr-profile testprof.profdata $(TEST_BUNDLE_PATH)

cover-full: cover
	xcrun llvm-cov show -instr-profile testprof.profdata $(TEST_BUNDLE_PATH)

clean:
	rm -rf .build/ default.profraw testprof.profdata
