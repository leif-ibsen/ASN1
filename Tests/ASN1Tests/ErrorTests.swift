//
//  ErrorTests.swift
//  ASN1Tests
//
//  Created by Leif Ibsen on 24/07/2021.
//

import XCTest

class ErrorTests: XCTestCase {

    func testBitString() {
        // unused > 7
        do {
            let _ = try ASN1BitString([1, 2, 3], 8)
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongInput exception")
        }

        // empty input, unused > 0
        do {
            let _ = try ASN1BitString([], 1)
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongData exception")
        }
    }
    
    func testBoolean() {
        // wrong length = 0
        do {
            let b: Bytes = [1, 0, 0]
            let _ = try ASN1.build(b)
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongData exception")
        }

        // wrong length > 1
        do {
            let b: Bytes = [1, 2, 0]
            let _ = try ASN1.build(b)
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongData exception")
        }
    }

    func testInteger() {
        // empty input
        do {
            let _ = try ASN1Integer([])
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongData exception")
        }
    }
    
    func testNull() {
        // wrong length
        do {
            let b: Bytes = [5, 1, 0]
            let _ = try ASN1.build(b)
            XCTFail("Expected wrongData exception")
        } catch ASN1Exception.wrongData(_) {
        } catch {
            XCTFail("Expected wrongData exception")
        }
    }

    func testObjectIdentifier() {
        XCTAssertNil(ASN1ObjectIdentifier(""))
        XCTAssertNil(ASN1ObjectIdentifier("."))
        XCTAssertNil(ASN1ObjectIdentifier("a.b"))
        XCTAssertNil(ASN1ObjectIdentifier("-1.1"))
        XCTAssertNil(ASN1ObjectIdentifier("1.-1"))
        XCTAssertNil(ASN1ObjectIdentifier("2.-1"))
        XCTAssertNil(ASN1ObjectIdentifier("-2.1"))
        XCTAssertNil(ASN1ObjectIdentifier("0.40"))
        XCTAssertNil(ASN1ObjectIdentifier("1.40"))
        XCTAssertNil(ASN1ObjectIdentifier([128, 0]))
        XCTAssertNil(ASN1ObjectIdentifier("1"))
        XCTAssertNil(ASN1ObjectIdentifier("3.1"))
        XCTAssertNotNil(ASN1ObjectIdentifier("1.2.1234567890123456789012345678901234567890"))
        XCTAssertNil(ASN1ObjectIdentifier([]))
        var s = "1.1"
        for i in 0 ..< 10000 {
            s += "." + i.description
        }
        XCTAssertNotNil(ASN1ObjectIdentifier(s))
    }
    
    func testIndefinite() {
        do {
            let b: Bytes = [48, 128, 0, 0]
            let _ = try ASN1.build(b)
        } catch {
            XCTFail("Did not expect exception")
        }
        do {
            let b: Bytes = [4, 128, 4, 3, 1, 2, 3, 4, 2, 4, 5, 0, 0]
            let _ = try ASN1.build(b)
            XCTFail("Expected indefiniteLength exception")
        } catch ASN1Exception.indefiniteLength(_) {
        } catch {
            XCTFail("Expected indefiniteLength exception")
        }
    }
    
    func testLength() {
        do {
            let b: Bytes = [4, 133, 1, 2, 3, 4, 5, 0]
            let _ = try ASN1.build(b)
            XCTFail("Expected tooLong exception")
        } catch ASN1Exception.tooLong(_, _) {
        } catch {
            XCTFail("Expected tooLong exception")
        }

    }

}
