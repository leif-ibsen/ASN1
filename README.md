<h3><b>Description</b></h3>

The ASN1 package implements a subset of the ASN1 (Abstract Syntax Notation One) specification in Swift.
It is intended to support writing cryptographic applications like ECIES and ECDSA in Swift.

<h3><b>Dependencies</b></h3>

ASN1 requires Swift 5.0.

The ASN1 package depends on the BigInt package

    dependencies: [
        .package(url: "https://github.com/leif-ibsen/BigInt", from: "1.0.0"),
    ],

<h3><b>References</b></h3>

<ul>
<li>Burton S. Kaliski Jr.: A Layman's Guide to a Subset of ASN.1, BER, and DER, 1993</li>
<li>John Larmouth: ASN.1 Complete, Open Systems Solutions 1999</li>
</ul>
