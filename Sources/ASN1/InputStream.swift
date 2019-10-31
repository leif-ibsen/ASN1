//
//  InputStream.swift
//  ASN1
//
//  Created by Leif Ibsen on 30/10/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

import Foundation

class InputStream {
    
    private var stream: Data
    private var offset: Int
    
    init(_ stream: Data) {
        self.stream = stream
        self.offset = 0
    }
    
    func nextByte() -> Byte {
        let b = self.stream[self.offset]
        self.offset += 1
        return b
    }
    
    func nextBytes(_ bytes: inout Bytes) {
        bytes = stream.withUnsafeBytes { (x: UnsafePointer<Byte>) in Array(UnsafeBufferPointer(start: x + self.offset, count: bytes.count)) }
        self.offset += bytes.count
    }
    
    func nextBytes(_ length: Int) -> Bytes {
        var bytes = Bytes(repeating: 0, count: length)
        nextBytes(&bytes)
        return bytes
    }
    
    func getOffset() -> Int {
        return self.offset
    }
    
}
