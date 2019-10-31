//
//  ASN1Exception.swift
//  ASN1
//
//  Created by Leif Ibsen on 29/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

/// ASN1 exceptions
public enum ASN1Exception: Error {

    /// Length is too big
    case tooLong(length: Int)
    /// Unsupported tag
    case unsupportedTag(tag: Byte)
    /// Unsupported tag class
    case unsupportedTagClass(tagClass: Byte)

}
