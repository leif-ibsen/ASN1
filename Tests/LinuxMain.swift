import XCTest

import ASN1Tests

var tests = [XCTestCaseEntry]()
tests += ASN1Tests.allTests()
XCTMain(tests)
