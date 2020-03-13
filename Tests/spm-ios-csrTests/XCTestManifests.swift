import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(spm_ios_csrTests.allTests),
    ]
}
#endif
