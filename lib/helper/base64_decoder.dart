library Base64Decoder;
import 'dart:typed_data';

class Base64Decoder {

  List<int> _decodingTable;

  Base64Decoder() {
    _createDecodingTable();
  }

  Uint8List decode(String encoded) {
    assert(encoded.length % 4 == 0);

    int decodedLength = _getDecodedBufferSize(encoded);
    Uint8List decoded = new Uint8List(decodedLength);

    int decodeIndex = 0;
    int encodeIndex = 0;
    int encodeLengthMinus4 = encoded.length - 4;

    int sextet0;
    int sextet1;
    int sextet2;
    int sextet3;
    int triple;

    while (encodeIndex < encodeLengthMinus4) {
      sextet0 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] << 18;
      sextet1 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] << 12;
      sextet2 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] <<  6;
      sextet3 = _decodingTable[encoded.codeUnitAt(encodeIndex++)];
      triple  = sextet0 | sextet1 | sextet2 | sextet3;

      decoded[decodeIndex++] = (triple & 0xff0000) >> 16;
      decoded[decodeIndex++] = (triple & 0xff00)   >>  8;
      decoded[decodeIndex++] = (triple & 0xff);
    }

    sextet0 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] << 18;
    sextet1 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] << 12;
    sextet2 = _decodingTable[encoded.codeUnitAt(encodeIndex++)] <<  6;
    sextet3 = _decodingTable[encoded.codeUnitAt(encodeIndex++)];
    triple  = sextet0 | sextet1 | sextet2 | sextet3;

    decoded[decodeIndex++] = (triple & 0xff0000) >> 16;

    if (decodedLength > decodeIndex) {
      decoded[decodeIndex++] = (triple & 0xff00) >> 8;

      if (decodedLength > decodeIndex) {
        decoded[decodeIndex++] = (triple & 0xff);
      }
    }

    return decoded;
  }

/// Creates a table used to decode Base64 values.
  void _createDecodingTable() {
    final List<int> encodingTable = [
        // A-Z [65-90]
        65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
        // a-z [97-122]
        97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122,
        // 0-9 [48-57]
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
        // +
        43,
        // /
        47
    ];

    _decodingTable = new List<int>.filled(256, 0);

    int encodingTableLength = encodingTable.length;

    for (int i = 0; i < encodingTableLength; ++i) {
      _decodingTable[encodingTable[i]] = i;
    }
  }

  static int _getDecodedBufferSize(String encoded) {
    int encodedLength = encoded.length;
    int decodeLength = (encodedLength ~/ 4) * 3;

    if (encoded[encodedLength - 1] != '=') {
      return decodeLength;
    }

    return decodeLength - ((encoded[encodedLength - 2] == '=') ? 2 : 1);
  }
}