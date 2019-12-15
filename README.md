<h3><b>Description</b></h3>

The ASN1 package implements a subset of the ASN1 (Abstract Syntax Notation One) specification in Swift.
It is intended to be used in writing cryptographic applications like ECIES and ECDSA in Swift.

ASN1 supports:
<ul>
<li>Building ASN1 structures from their byte array representation</li>
<li>DER encoding of ASN1 structures</li>
<li>Displaying ASN1 structures</li>
<li>Definite length and indefinite length encoding</li>
<li>Tag numbers less than 128</li>
<li>Universal (0) and context-specific (2) tag classes</li>
</ul>

It supports the following ASN1 types:
<ul>
<li>BitString</li>
<li>BMPString</li>
<li>Boolean</li>
<li>GeneralizedTime</li>
<li>IA5String</li>
<li>Integer</li>
<li>Null</li>
<li>ObjectIdentifier</li>
<li>OctetString</li>
<li>PrintableString</li>
<li>Sequence</li>
<li>Set</li>
<li>T61String</li>
<li>UTCTime</li>
<li>UTF8String</li>
</ul>

<h3><b>Example 1</b></h3>

Example 1 shows how to decode a byte array containing an ASN1 structure.

    import ASN1
    import BigInt

    // ASN1 encoding of a private key for the brainpoolP160r1 elliptic curve domain
    let keyBytes: Bytes = [48, 84, 2, 1, 1, 4, 20, 41, 214, 158, 187, 255, 44, 248,
     248, 164, 95, 252, 51, 1, 186, 40, 137, 9, 116, 150, 79, 160, 11, 6, 9, 43, 36,
      3, 3, 2, 8, 1, 1, 1, 161, 44, 3, 42, 0, 4, 48, 46, 251, 62, 213, 248, 5, 82,
     62, 98, 171, 43, 207, 1, 175, 50, 2, 120, 7, 195, 112, 178, 217, 62, 194, 11,
     215, 59, 27, 221, 93, 51, 231, 135, 77, 120, 34, 107, 185, 154]
    
    // Build the ASN1 structure - we happen to know it is a sequence
    let seq = try ASN1.build(keyBytes) as! ASN1Sequence

    print(seq)

    // Extract the private key value - a large number
    let privBytes = seq.get(1) as! ASN1OctetString
    let privKey = BInt(magnitude: privBytes.value)

    print("Private key =", privKey)

giving</br>
    
    Sequence (4):
      Integer: 1
      Octet String (20): 29 d6 9e bb ff 2c f8 f8 a4 5f fc 33 01 ba 28 89 09 74 96 4f
      [0]:
        Object Identifier: 1.3.36.3.3.2.8.1.1.1
      [1]:
        Bit String (328): 00000100 00110000 00101110 11111011 00111110 11010101 11111000
                          00000101 01010010 00111110 01100010 10101011 00101011 11001111
                          00000001 10101111 00110010 00000010 01111000 00000111 11000011
                          01110000 10110010 11011001 00111110 11000010 00001011 11010111
                          00111011 00011011 11011101 01011101 00110011 11100111 10000111
                          01001101 01111000 00100010 01101011 10111001 10011010

    Private key = 238854808789429455904277046626010014418497476175


<h3><b>Example 2</b></h3>

Example 2 shows how to build an ASN1 structure programmatically and encode it to a byte array.

    import ASN1
    import BigInt

    let privKey = BInt("238854808789429455904277046626010014418497476175")!

    let seq = ASN1Sequence()
    seq.add(ASN1Integer(BInt(1))).add(ASN1OctetString(privKey.asMagnitudeBytes()))
    print(seq)
 
    let b = seq.encode()
    print("Byte array =", b)

giving</br>

    Sequence (2):
      Integer: 1
      Octet String (20): 29 d6 9e bb ff 2c f8 f8 a4 5f fc 33 01 ba 28 89 09 74 96 4f

    Byte array = [48, 25, 2, 1, 1, 4, 20, 41, 214, 158, 187, 255, 44, 248,
                  248, 164, 95, 252, 51, 1, 186, 40, 137, 9, 116, 150, 79]

<h3><b>Dependencies</b></h3>

ASN1 requires Swift 5.0.

The ASN1 package depends on the BigInt package

    dependencies: [
        .package(url: "https://github.com/leif-ibsen/BigInt", from: "1.1.0"),
    ],

<h3><b>References</b></h3>

<ul>
<li>Burton S. Kaliski Jr.: A Layman's Guide to a Subset of ASN.1, BER, and DER, 1993</li>
<li>John Larmouth: ASN.1 Complete, Open Systems Solutions 1999</li>
</ul>
