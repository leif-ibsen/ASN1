<h2><b>ASN1</b></h2>
The ASN1 package implements a subset of the ASN1 (Abstract Syntax Notation One) specification in Swift.
It is intended to be used in writing cryptographic applications like ECIES and ECDSA in Swift.

ASN1 functionality:
<ul>
<li>Building ASN1 structures from their byte array representation</li>
<li>DER encoding of ASN1 structures</li>
<li>Displaying ASN1 structures</li>
<li>Definite length encoding and decoding</li>
<li>Indefinite length decoding of sets and sequences</li>
<li>Tag numbers less than 128</li>
<li>Universal (0) and context-specific (2) tag classes</li>
</ul>

ASN1 requires Swift 5.0. It also requires that the Int and UInt types be 64 bit types.

Its documentation is build with Apple's DocC tool and published on GitHub Pages at this location

https://leif-ibsen.github.io/ASN1/documentation/asn1

The documentation is also available in the <i>ASN1.doccarchive</i> file.