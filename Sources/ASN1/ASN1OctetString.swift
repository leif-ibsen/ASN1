//
//  ASN1OctetString.swift
//  ASN1
//
//  Created by Leif Ibsen on 30/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

/// ASN1 OctetString class
public class ASN1OctetString: ASN1SimpleType, CustomStringConvertible {
    
    // MARK: - Initializers

    /// Constructs an ASN1OctetString instance from a byte array
    ///
    /// - Parameter value: Byte array
    public init(_ value: Bytes) {
        super.init(ASN1.TAG_OctetString, value)
    }
    
    // MARK: Computed properties
    
    /// Description of *self*
    public override var description: String {
        var sb = ""
        sb.append("Octet String (" + value.count.description + "):")
        for i in 0 ..< value.count {
            sb.append(" " + byte2hex(value[i]))
        }
        return sb
    }

}
