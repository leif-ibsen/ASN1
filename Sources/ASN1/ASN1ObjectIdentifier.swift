//
//  ASN1ObjectIdentifier.swift
//  ASN1
//
//  Created by Leif Ibsen on 29/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

/// ASN1 ObjectIdentifier class
public class ASN1ObjectIdentifier: ASN1SimpleType, CustomStringConvertible, Hashable {
    
    // MARK: - Initializers

    /// Constructs an ASN1ObjectIdentifier instance from a branch of an ASN1ObjectIdentifier
    ///
    /// - Parameters:
    ///   - oid: Object identifier
    ///   - branch: Branch number
    public init(_ oid: ASN1ObjectIdentifier, _ branch: Int) {
        let value = ASN1ObjectIdentifier.oid2bytes(oid.oid + "." + branch.description)
        self.oid = ASN1ObjectIdentifier.bytes2oid(value)
        super.init(ASN1.TAG_ObjectIdentifier, value)
    }

    /// Constructs an ASN1ObjectIdentifier instance from a String
    ///
    /// - Parameter oid: String value
    public init(_ oid: String) {
        self.oid = oid
        super.init(ASN1.TAG_ObjectIdentifier, ASN1ObjectIdentifier.oid2bytes(oid))
    }
    
    /// Constructs an ASN1ObjectIdentifier instance from a byte array
    ///
    /// - Parameter value: Byte array
    public init(_ value: Bytes) {
        self.oid = ASN1ObjectIdentifier.bytes2oid(value)
        super.init(ASN1.TAG_ObjectIdentifier, value)
    }
    
    // MARK: Stored properties
    
    /// Value of *self*
    public let oid: String

    // MARK: Computed properties
    
    /// Description of *self*
    public override var description: String {
        return "Object Identifier: " + self.oid
    }

    // MARK: - Functions

    /// Get a specified branch of *self*
    ///
    /// - Parameter i: Branch number
    /// - Returns: The specified branch
    public func branch(_ i: Int) -> ASN1ObjectIdentifier {
        return ASN1ObjectIdentifier(self, i)
    }

    /// The hash function
    ///
    /// - Parameter into: The hasher
    public func hash(into: inout Hasher) {
        into.combine(self.oid)
    }

    static func oid2bytes(_ oid: String) -> Bytes {
        let components = oid.components(separatedBy: ".")
        if components.count < 2 || components.count > 32 {
            return []
        }
        var bytes = Bytes()
        bytes.append(Byte(components[0])! * 40 + Byte(components[1])!)
        for i in 2 ..< components.count {
            let x = Int(components[i])!
            var ll = x
            var la = [Int](repeating: 0, count: 32)
            var xx = 0
            while ll > 0 {
                la[xx] = ll & 0x7f
                xx += 1
                ll >>= 7
            }
            if xx > 1 {
                for ii in (1 ... xx - 1).reversed() {
                    bytes.append(Byte(la[ii] | 0x80))
                }
            }
            bytes.append(Byte(la[0]))
        }
        return bytes
    }
    
    static func bytes2oid(_ bytes: Bytes) -> String {
        if bytes.count == 0 {
            return ""
        }
        var sb = (bytes[0] / 40).description + "." + (bytes[0] % 40).description
        var size = 2
        var l = 0
        for i in 1 ..< bytes.count {
            l *= 128
            l += Int(bytes[i] & 0x7f)
            if bytes[i] < 128 {
                sb.append("." + l.description)
                l = 0
                size += 1
            }
        }
        return sb
    }
    
}
