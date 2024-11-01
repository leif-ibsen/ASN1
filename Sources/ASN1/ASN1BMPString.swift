//
//  ASN1BMPString.swift
//  ASN1
//
//  Created by Leif Ibsen on 01/11/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

/// The `ASN1` BMPString class
public class ASN1BMPString: ASN1SimpleType, CustomStringConvertible {
    
    // MARK: - Initializers
    
    /// Constructs an `ASN1BMPString` instance from a byte array
    ///
    /// - Parameter s: The byte array
    public init(_ s: Bytes) {
        super.init(ASN1.TAG_BMPString, s)
    }
    
    /// Constructs an `ASN1BMPString` instance from a String value
    ///
    /// - Parameter s: The String value
    public convenience init(_ s: String) {
        self.init(ASN1.getUTF16Bytes(s))
    }

    // MARK: - Computed properties

    /// Description of `self`
    public override var description: String {
        return "BMPString: " + String(bytes: self.value, encoding: .utf16)!
    }

}
