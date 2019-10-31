//
//  ASN1Ctx.swift
//  ASN1
//
//  Created by Leif Ibsen on 30/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

import Foundation

/// ASN1 Ctx class
public class ASN1Ctx: ASN1, CustomStringConvertible {
    
    // MARK: - Initializers

    /// Constructs an ASN1Ctx instance
    ///
    /// - Parameters:
    ///   - tag: Instance tag
    ///   - value: Instance value
    public init(_ tag: Byte, _ value: ASN1) {
        self.value = value
        super.init(tag)
    }
    
    // MARK: Stored properties
    
    /// Value of *self*
    public let value: ASN1
    
    // MARK: Computed properties
    
    /// Description of *self*
    public override var description: String {
        var s = ""
        doDump(&s, 0)
        return s
    }

    override func doEncode(_ bytes: inout Bytes) {
        bytes.append(self.tag | 0xa0)
        let b = self.value.encode()
        makeLength(b.count, &bytes)
        bytes += b
    }
    
    override func getContentLength() -> Int {
        return self.value.getTotalLength()
    }
    
    override func doDump(_ data: inout String, _ level: Int) {
        self.indent(&data, level)
        var s = "[" + self.tag.description + "] ="
        self.value.doDump(&s, level + 1)
        data += s
    }

}
