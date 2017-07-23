//
//  Response.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation

public struct GetResponse {
  public let cas: UInt64
  public let key: String
  public let doc: Any
}

public struct StoreResponse {
  public let cas: UInt64
  public let key: String
}

public struct RemoveResponse {
  public let cas: UInt64
  public let key: String
}
