import CWyhash

public struct WyRandomGenerator: RandomNumberGenerator {
  
  @usableFromInline
  internal var seed: UInt64
  
  // MARK: -
  
  @inlinable
  public mutating func next() -> UInt64 { wyrand(&seed) }
  
  @inlinable
  public mutating func nextU01() -> Double { wy2u01(wyrand(&seed)) }
  
  @inlinable
  public mutating func nextGau() -> Double { wy2gau(wyrand(&seed)) }
  
  // MARK: -
  
  @inlinable
  public init() { seed = UInt64(time(nil)) }
  
  @inlinable
  public init(seed: UInt64) { self.seed = seed }
}
