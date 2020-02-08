import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(WyRandomGeneratorTests.allTests),
    testCase(WyHashTests.allTests),
  ]
}
#endif
