//
//  WyHash.swift
//  PSWyhash
//
//  Created by Ruslan Lutfullin on 2/7/20.
//

import Foundation
import CWyhash

public struct WyHash {
  
  public static var byteCount: Int { 8 }
  
  // MARK: -
  
  @usableFromInline
  internal var seed: UInt64
  
  @usableFromInline
  internal var secret = [UInt64]()
    
  // MARK: -
  
  @inlinable
  public init(seed: UInt64) {
    self.seed = seed
    secret.reserveCapacity(6)
    make_secret(self.seed, &secret)
  }
  
  @inlinable
  public init() { self.init(seed: UInt64(time(nil))) }
}

extension WyHash {
  
  @inlinable
  public func hash(_ data: Data) -> Data {
    data.withUnsafeBytes {
      var hash = wyhash($0.baseAddress!, UInt64($0.count), seed, secret)
      return Data(bytes: &hash, count: Self.byteCount)
    }
  }
}

extension WyHash {
  
  @inlinable
  public static func hash(_ data: Data, seed: UInt64? = nil) -> Data {
    if let seed = seed {
      return Self.init(seed: seed).hash(data)
    } else {
      return Self.init().hash(data)
    }
  }
}
