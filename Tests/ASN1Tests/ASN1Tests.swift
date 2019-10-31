import XCTest
@testable import ASN1
@testable import BigInt

final class ASN1Tests: XCTestCase {
    
    func testBitString() throws {
        let a = ASN1BitString([1, 2, 3], 3)
        let aa = try ASN1.build(a.encode())
        XCTAssertTrue(aa == a)
        let b = ASN1BitString([], 0)
        XCTAssertTrue(b.description == "Bit String (0):")
        let bb = ASN1BitString([128], 7)
        XCTAssertTrue(bb.description == "Bit String (1): 1")
    }

    func testBoolean() throws {
        let a1 = ASN1Boolean(true)
        let a2 = ASN1Boolean(false)
        let aa1 = try ASN1.build(a1.encode())
        let aa2 = try ASN1.build(a2.encode())
        XCTAssertTrue(aa1 == a1)
        XCTAssertTrue(aa2 == a2)
    }
    
    func testCtx() throws {
        let a1 = ASN1Ctx(19, ASN1Boolean(true))
        let aa1 = try ASN1.build(a1.encode())
        XCTAssertTrue(aa1 == a1)
    }
    
    func testString() throws {
        let s = "abcæøåÆØÅxyzcl´es publiques\u{301}"
        let a = ASN1BMPString(s)
        let b = ASN1IA5String(s)
        let c = ASN1PrintableString(s)
        let d = ASN1T61String(s)
        let e = ASN1UTF8String(s)
        let aa = try ASN1.build(a.encode())
        let bb = try ASN1.build(b.encode())
        let cc = try ASN1.build(c.encode())
        let dd = try ASN1.build(d.encode())
        let ee = try ASN1.build(e.encode())
        XCTAssertTrue(aa == a)
        XCTAssertTrue(bb == b)
        XCTAssertTrue(cc == c)
        XCTAssertTrue(dd == d)
        XCTAssertTrue(ee == e)
    }

    func testTime() throws {
        let date = Date()
        let a = ASN1GeneralizedTime(date)
        let b = ASN1UTCTime(date)
        let aa = try ASN1.build(a.encode())
        let bb = try ASN1.build(b.encode())
        XCTAssertTrue(aa == a)
        XCTAssertTrue(bb == b)
    }

    func testInteger() throws {
        let a = ASN1Integer(BInt.ZERO)
        let b = ASN1Integer(BInt("-1234567890123456789012345678901234567890")!)
        let c = ASN1Integer([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        let d = ASN1Integer([128, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        let aa = try ASN1.build(a.encode())
        let bb = try ASN1.build(b.encode())
        let cc = try ASN1.build(c.encode())
        let dd = try ASN1.build(d.encode())
        XCTAssertTrue(aa == a)
        XCTAssertTrue(bb == b)
        XCTAssertTrue(cc == c)
        XCTAssertTrue(dd == d)
    }

    func testNull() throws {
        let a = ASN1Null()
        let aa = try ASN1.build(a.encode())
        XCTAssertTrue(aa == a)
    }

    func testObjectIdentifier() throws {
        let a = ASN1ObjectIdentifier("1.2.3.4")
        let aa = try ASN1.build(a.encode())
        XCTAssertTrue(aa == a)
        let b = ASN1ObjectIdentifier([])
        let bb = try ASN1.build(b.encode())
        XCTAssertTrue(bb == b)
    }
    
    func testOctetString() throws {
        let a1 = ASN1OctetString([])
        let a2 = ASN1OctetString([1, 2, 3, 4, 5])
        let aa1 = try ASN1.build(a1.encode())
        let aa2 = try ASN1.build(a2.encode())
        XCTAssertTrue(aa1 == a1)
        XCTAssertTrue(aa2 == a2)
    }
    
    func testSequence() {
        let date = Date()
        let a1 = ASN1Sequence()
        a1.add(ASN1IA5String("IA5String"))
        a1.add(ASN1.ONE)
        a1.add(ASN1ObjectIdentifier("1.2.3"))
        a1.add(ASN1UTCTime(date))
        let a2 = ASN1Sequence()
        a2.add(ASN1IA5String("IA5String"))
        a2.add(ASN1.ONE)
        a2.add(ASN1ObjectIdentifier("1.2.3"))
        XCTAssertTrue(a1 != a2)
        a2.add(ASN1UTCTime(date))
        XCTAssertTrue(a1 == a2)
    }
    
    func testSet() {
        let date = Date()
        let asn1set1 = ASN1Set()
        asn1set1.add(ASN1IA5String("IA5String"))
        asn1set1.add(ASN1.ONE)
        asn1set1.add(ASN1ObjectIdentifier("1.2.3"))
        asn1set1.add(ASN1UTCTime(date))
        let asn1set2 = ASN1Set()
        asn1set2.add(ASN1UTCTime(date))
        asn1set2.add(ASN1ObjectIdentifier("1.2.3"))
        asn1set2.add(ASN1.ONE)
        XCTAssertTrue(asn1set1 != asn1set2)
        asn1set2.add(ASN1IA5String("IA5String"))
        XCTAssertTrue(asn1set1 == asn1set2)
    }
    
    static var allTests = [
        ("test1BitString", testBitString),
        ("testBoolean", testBoolean),
        ("testCtx", testCtx),
        ("testString", testString),
        ("testTime", testTime),
        ("testInteger", testInteger),
        ("testNull", testNull),
        ("testObjectIdentifier", testObjectIdentifier),
        ("testOctetString", testOctetString),
        ("testSequence", testSequence),
        ("testSet", testSet),
        ]
}
