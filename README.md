## ASN1

The ASN1 package implements a subset of the ASN1 (Abstract Syntax Notation One) specification in Swift.
It is intended to be used in writing cryptographic applications like ECIES and ECDSA in Swift.

ASN1 functionality:

* Building ASN1 structures from their byte array representation
* DER encoding of ASN1 structures
* Displaying ASN1 structures
* Definite length encoding and decoding
* Indefinite length decoding of sets and sequences
* Tag numbers less than 128
* Universal (0) and context-specific (2) tag classes


ASN1 requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

Its documentation is build with the DocC tool and published on GitHub Pages at this location:

https://leif-ibsen.github.io/ASN1/documentation/asn1

The documentation is also available in the *ASN1.doccarchive* file.