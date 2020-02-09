//
//  WyHashTests.swift
//  PSWyhashTests
//
//  Created by Ruslan Lutfullin on 2/7/20.
//

import XCTest
@testable import PSWyhash

final class WyHashTests: XCTestCase {
  
  func testHash() {
    let pairs: KeyValuePairs = [
      "": "51b8bf30df31cb63",
      "a": "b996838c67de0f47",
      "abc": "a93ea18188ed1632",
      "message digest": "5fa22e94060b12eb",
      "abcdefghijklmnopqrstuvwxyz": "58bfb28061a1a6ac",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789": "364ea03f87712299",
      "12345678901234567890123456789012345678901234567890123456789012345678901234567890": "df7cb6ca9d349263",
    ]
    
    pairs
      .enumerated()
      .forEach {
        XCTAssertEqual(
          WyHash
            .hash($0.element.key.data(using: .ascii, allowLossyConversion: true)!, seed: UInt64($0.offset))
            .hexString,
          $0.element.value
        )
    }
  }
  
  func testDataExtensions() throws {
    let pairs: KeyValuePairs<UInt64, String> = [
      7190896064692467793: "51b8bf30df31cb63",
      5120555837663975097: "b996838c67de0f47",
      3609333321930194601: "a93ea18188ed1632",
      16938613271377650271: "5fa22e94060b12eb",
      12440808460800671576: "58bfb28061a1a6ac",
      11034506862713130550: "364ea03f87712299",
      7174855008670088415: "df7cb6ca9d349263",
    ]
    
    try pairs
      .forEach {
        var key = $0.key
        let data = Data(bytes: &key, count: WyHash.byteCount)
        
        XCTAssertEqual(data, try Data(hexString: $0.value))
        XCTAssertEqual(data.hexString, $0.value)
      }
  }
  
  // MARK: -
  
  static var allTests = [
    ("testHash", testHash),
    ("testDataExtensions", testDataExtensions),
  ]
}
