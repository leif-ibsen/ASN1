//
//  ASN1.swift
//  ASN1
//
//  Created by Leif Ibsen on 29/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

import Foundation
import BigInt

/// Unsigned 8 bit value
public typealias Byte = UInt8
/// Array of unsigned 8 bit values
public typealias Bytes = [UInt8]

/// The superclass of all ASN1-classes
public class ASN1: Equatable {

    // MARK: - Constants

    /// ASN1 null value
    public static let NULL = ASN1Null()
    /// ASN1 integer 0
    public static let ZERO = ASN1Integer(BInt.ZERO)
    /// ASN1 integer 1
    public static let ONE = ASN1Integer(BInt.ONE)

    /// ASN1 Boolean tag = 1
    public static let TAG_Boolean = Byte(1)
    /// ASN1 Integer tag = 2
    public static let TAG_Integer = Byte(2)
    /// ASN1 BitString tag = 3
    public static let TAG_BitString = Byte(3)
    /// ASN1 OctetString tag = 4
    public static let TAG_OctetString = Byte(4)
    /// ASN1 Null tag = 5
    public static let TAG_Null = Byte(5)
    /// ASN1 ObjectIdentifier tag = 6
    public static let TAG_ObjectIdentifier = Byte(6)
    /// ASN1 UTF8String tag = 12
    public static let TAG_UTF8String = Byte(12)
    /// ASN1 Sequence tag = 16
    public static let TAG_Sequence = Byte(16)
    /// ASN1 Set tag = 17
    public static let TAG_Set = Byte(17)
    /// ASN1 PrintableString tag = 19
    public static let TAG_PrintableString = Byte(19)
    /// ASN1 T61String tag = 20
    public static let TAG_T61String = Byte(20)
    /// ASN1 IA5String tag = 22
    public static let TAG_IA5String = Byte(22)
    /// ASN1 UTCTime tag = 23
    public static let TAG_UTCTime = Byte(23)
    /// ASN1 GeneralizedTime tag = 24
    public static let TAG_GeneralizedTime = Byte(24)
    /// ASN1 BMPString tag = 30
    public static let TAG_BMPString = Byte(30)

    static let hex = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ]
    static let bin = [ "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010",
    "1011", "1100", "1101", "1110", "1111" ]

    init(_ tag: Byte) {
        self.tag = tag
    }
    
    // MARK: Stored properties
    
    /// The ASN1 tag
    public let tag: Byte

    // MARK: Computed properties

    /// Description of *self*
    public var description: String { get { return "ASN1" } }

    // MARK: Functions

    /// Equality of two ASN1 instances
    ///
    /// - Parameters:
    ///   - a1: an ASN1 instance
    ///   - a2: an ASN1 instance
    /// - Returns: *true* if a1 and a2 have the same tag and same value, *false* otherwise
    public static func == (a1: ASN1, a2: ASN1) -> Bool {
        if type(of: a1) != type(of: a2) {
            return false
        }
        switch type(of: a1) {
        case is ASN1BitString.Type:
            let x1 = a1 as! ASN1BitString
            let x2 = a2 as! ASN1BitString
            return x1.bits == x2.bits && x1.unused == x2.unused
            
        case is ASN1Boolean.Type:
            let x1 = a1 as! ASN1Boolean
            let x2 = a2 as! ASN1Boolean
            return x1.value == x2.value
            
        case is ASN1Collection.Type:
            let x1 = a1 as! ASN1Collection
            let x2 = a2 as! ASN1Collection
            if x1.value.count != x2.value.count {
                return false
            }
            for i in 0 ..< x1.value.count {
                if x1.value[i] != x2.value[i] {
                    return false
                }
            }
            return true
            
        case is ASN1Ctx.Type:
            let x1 = a1 as! ASN1Ctx
            let x2 = a2 as! ASN1Ctx
            return x1.value == x2.value
            
        case is ASN1Integer.Type:
            let x1 = a1 as! ASN1Integer
            let x2 = a2 as! ASN1Integer
            return x1.value == x2.value
            
        case is ASN1Null.Type:
            return true

        case is ASN1ObjectIdentifier.Type:
            let x1 = a1 as! ASN1ObjectIdentifier
            let x2 = a2 as! ASN1ObjectIdentifier
            return x1.oid == x2.oid
            
        case is ASN1SimpleType.Type:
            let x1 = a1 as! ASN1SimpleType
            let x2 = a2 as! ASN1SimpleType
            return x1.value == x2.value
            
        default:
            return false
        }
    }

    func indent(_ data: inout String, _ level: Int) {
        for _ in 0 ..< level {
            data.append("  ")
        }
    }

    func doDump(_ data: inout String, _ level: Int) {
        self.indent(&data, level)
        data += self.description
        data += "\n"
    }

    func doEncode(_ bytes: inout Bytes) {
        precondition(false, "ASN1.doEncode called")
    }
    
    func getContentLength() -> Int {
        precondition(false, "ASN1.getContentLength called")
        return 0
    }

    func makeLength(_ length: Int, _ bytes: inout Bytes) {
        if length < 128 {
            bytes.append(Byte(length))
        } else if length < 256 {
            bytes.append(Byte(0x81))
            bytes.append(Byte(length))
        } else if length < 256 * 256 {
            bytes.append(Byte(0x82))
            bytes.append(Byte(length >> 8))
            bytes.append(Byte(length & 0xff))
        } else if length < 256 * 256 * 256 {
            bytes.append(Byte(0x83))
            bytes.append(Byte(length >> 16))
            bytes.append(Byte((length >> 8) & 0xff))
            bytes.append(Byte(length & 0xff))
        } else {
            bytes.append(Byte(0x84))
            bytes.append(Byte(length >> 24))
            bytes.append(Byte((length >> 16) & 0xff))
            bytes.append(Byte((length >> 8) & 0xff))
            bytes.append(Byte(length & 0xff))
        }
    }

    func getLengthLength() -> Int {
        let length = getContentLength()
        if length < 128 {
            return 1
        } else if length < 256 {
            return 2
        } else if length < 256 * 256 {
            return 3
        } else if length < 256 * 256 * 256 {
            return 4
        } else {
            return 5
        }
    }
    
    func getTotalLength() -> Int {
        return getContentLength() + getLengthLength() + 1
    }
    
    /// Encode *self* as a byte array
    ///
    /// - Returns: ASN1 DER encoding of *self*
    public func encode() -> Bytes {
        var bytes = Bytes()
        doEncode(&bytes)
        return bytes
    }

    func byte2hex(_ b: Byte) -> String {
        return ASN1.hex[Int((b >> 4) & 0x0f)] + ASN1.hex[Int(b & 0x0f)]
    }
    
    func byte2bin(_ b: Byte) -> String {
        return ASN1.bin[Int((b >> 4) & 0x0f)] + ASN1.bin[Int(b & 0x0f)]
    }

    /// Build an ASN1 instance from a Data stream
    ///
    /// - Parameter stream: Data instance containing the ASN1 DER encoding
    /// - Returns: An ASN1 instance
    /// - Throws: An ASN1Exception if the input is invalid
    public static func build(_ stream: Data) throws -> ASN1 {
        return try doBuild(InputStream(stream))
    }
    
    /// Build an ASN1 instance from a byte array
    ///
    /// - Parameter bytes: Byte array containing the ASN1 DER encoding
    /// - Returns: An ASN1 instance
    /// - Throws: An ASN1Exception if the input is invalid
    public static func build(_ bytes: Bytes) throws -> ASN1 {
        return try doBuild(InputStream(Data(bytes)))
    }
    
    static func getLength(_ input: InputStream) throws -> Int {
        var length: Int
        let l = input.nextByte()
        if l > 127 {
            let lb = l & 0x7f
            if lb == 1 {
                length = Int(input.nextByte())
            } else if lb == 2 {
                length = Int(input.nextByte()) << 8 | Int(input.nextByte())
            } else {
                throw ASN1Exception.tooLong(length: Int(lb))
            }
        } else {
            length = Int(l)
        }
        return length
    }

    static func doBuild(_ input: InputStream) throws -> ASN1 {
        let nb = input.nextByte()
        let tag = nb & 0x1f
        let tagClass = (nb >> 6) & 0x3
        let length = try getLength(input)
        if tagClass == 2 {
            return ASN1Ctx(tag, try ASN1.build(input.nextBytes(length)))
        } else if tagClass == 0 {
            switch tag {
            case TAG_Boolean:
                return ASN1Boolean(input.nextByte() != 0)
                
            case TAG_UTCTime:
                return ASN1UTCTime(input.nextBytes(length))
                
            case TAG_GeneralizedTime:
                return ASN1GeneralizedTime(input.nextBytes(length))
                
            case TAG_IA5String:
                return ASN1IA5String(input.nextBytes(length))
                
            case TAG_PrintableString:
                return ASN1PrintableString(input.nextBytes(length))
                
            case TAG_T61String:
                return ASN1T61String(input.nextBytes(length))
                
            case TAG_BMPString:
                return ASN1BMPString(input.nextBytes(length))
                
            case TAG_UTF8String:
                return ASN1UTF8String(input.nextBytes(length))
                
            case TAG_Integer:
                return ASN1Integer(input.nextBytes(length))
                
            case TAG_OctetString:
                return ASN1OctetString(input.nextBytes(length))
                
            case TAG_Sequence:
                let here = input.getOffset()
                var list = [ASN1]()
                while input.getOffset() < here + length {
                    let asn1 = try doBuild(input)
                    list.append(asn1)
                }
                return ASN1Sequence(list)
                
            case TAG_Set:
                let here = input.getOffset()
                var list = [ASN1]()
                while input.getOffset() < here + length {
                    let asn1 = try doBuild(input)
                    list.append(asn1)
                }
                return ASN1Set(list)
                
            case TAG_ObjectIdentifier:
                return ASN1ObjectIdentifier(input.nextBytes(length))
                
            case TAG_BitString:
                let unused = input.nextByte()
                return ASN1BitString(input.nextBytes(length - 1), unused)
                
            case TAG_Null:
                return ASN1.NULL
                
            default:
                throw ASN1Exception.unsupportedTag(tag: tag)
            }
        } else {
            throw ASN1Exception.unsupportedTagClass(tagClass: tagClass)
        }
    }

    static func getASCIIBytes(_ s: String) -> Bytes {
        var bytes = Bytes()
        for x in s.utf16 {
            bytes.append(x < 0x80 ? Byte(x) : 63)
        }
        return bytes
    }

    static func getISO8859Bytes(_ s: String) -> Bytes {
        var bytes = Bytes()
        for x in s.utf16 {
            bytes.append(x < 0x100 ? Byte(x) : 63)
        }
        return bytes
    }

    static func getUTF8Bytes(_ s: String) -> Bytes {
        var bytes = Bytes()
        for x in s.utf16 {
            if x < 0x80 {
                bytes.append(Byte(x))
            } else if x < 0x800 {
                bytes.append(Byte(0xc0 | (x >> 6)))
                bytes.append(Byte(0x80 | (x & 0x3f)))
            } else {
                bytes.append(63)
            }
        }
        return bytes
    }

    static func getUTF16Bytes(_ s: String) -> Bytes {
        var bytes = Bytes()
        for x in s.utf16 {
            bytes.append(Byte((x >> 8) & 0xff))
            bytes.append(Byte(x & 0xff))
        }
        return bytes
    }

}

extension Data {
    
    mutating func append(_ s: String) {
        self.append(s.data(using: .utf8)!)
    }
}
