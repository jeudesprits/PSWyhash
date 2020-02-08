import XCTest
@testable import PSWyhash

final class WyRandomGeneratorTests: XCTestCase {
  
  func testBasic() {
    var gen = WyRandomGenerator(seed: 42)
    XCTAssertEqual(gen.next(), 12558987674375533620)
    XCTAssertEqual(gen.next(), 16846851108956068306)
    XCTAssertEqual(gen.next(), 14652274819296609082)
  }
  
  func testShuffled() {
    var g = WyRandomGenerator(seed: 42)
    XCTAssertEqual((1...10).shuffled(using: &g), [1, 3, 5, 2, 4, 9, 6, 10, 8, 7])
  }
  
  func testNumberSequence() {
    var numbers = sequence(state: WyRandomGenerator(seed: 42)) { Int.random(in: Int.min...Int.max, using: &$0) }
    
    // Array initializer takes a copy of numbers value,
    // because `UnfoldSequence` and `Wyhash64` are both value types.
    XCTAssertEqual([Int](numbers.prefix(2)), [-5887756399334017996, -1599892964753483310])
    XCTAssertEqual(numbers.next(), -5887756399334017996)
    
    XCTAssertEqual([Int](numbers.prefix(2)), [-1599892964753483310, -3794469254412942534])
    XCTAssertEqual(numbers.next(), -1599892964753483310)
    XCTAssertEqual(numbers.next(), -3794469254412942534)
    
    measure { _ = [Int](numbers.lazy.prefix(524288)) }
  }
  
  func testNumberSequenceBoundedPerformance() {
    let numbers1 = sequence(state: WyRandomGenerator(seed: 42)) {
      Int.random(in: Int.min...(Int.max / 2 + 1), using: &$0)
    }
    
   measure { _ = [Int](numbers1.lazy.prefix(524288)) }
  }
  
  func testRawGeneratorPerformance() {
    var g = WyRandomGenerator(seed: 42)
    var a = [UInt64](repeating: UInt64(0), count: 524288)
    
    measure { a.indices.forEach { a[$0] = g.next() } }
  }
  
  func testBoundedGeneratorPerformance() {
    var g = WyRandomGenerator(seed: 42)
    var a = [UInt64](repeating: UInt64(0), count: 524288)
    let b = UInt64.max / 2 + 1
    
    measure { a.indices.forEach { a[$0] = g.next(upperBound: b) } }
  }
  
  // MARK: -
  
  static var allTests = [
    ("testBasic", testBasic),
    ("testShuffled", testShuffled),
    ("testNumberSequence", testNumberSequence),
    ("testNumberSequenceBoundedPerformance", testNumberSequenceBoundedPerformance),
    ("testRawGeneratorPerformance", testRawGeneratorPerformance),
    ("testBoundedGeneratorPerformance", testBoundedGeneratorPerformance),
  ]
}
