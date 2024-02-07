# ``ASN1``

## Overview

The ASN1 package implements a subset of the ASN1 (Abstract Syntax Notation One) specification in Swift.
It is intended to be used in writing cryptographic applications like ECIES and ECDSA in Swift.

> Important:
ASN1 requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

### ASN1 functionality

* Building ASN1 structures from their byte array representation
* DER encoding of ASN1 structures
* Displaying ASN1 structures
* Definite length encoding and decoding
* Indefinite length decoding of sets and sequences
* Tag numbers less than 128
* Universal (0) and context-specific (2) tag classes

### Supported ASN1 types

* BitString
* BMPString
* Boolean
* GeneralizedTime
* IA5String
* Integer
* Null
* ObjectIdentifier
* OctetString
* PrintableString
* Sequence
* Set
* T61String
* UTCTime
* UTF8String

## Topics

- <doc:Usage>
- <doc:Examples>
- <doc:Dependencies>
- <doc:References>

