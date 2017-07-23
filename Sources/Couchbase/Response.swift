//
//  Response.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation

public struct GetResponse {
  let cas: UInt64
  let key: String
  let doc: Any
}

public struct StoreResponse {
  let cas: UInt64
  let key: String
}
