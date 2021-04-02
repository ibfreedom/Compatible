import XCTest

import CompatibleTests

var tests = [XCTestCaseEntry]()
tests += CompatibleTests.allTests()
XCTMain(tests)
