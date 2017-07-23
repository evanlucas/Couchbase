//
//  Cookie.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation

class Cookie {
  let id: UUID
  let key: String
  
  init(id: UUID, key: String) {
    self.id = id
    self.key = key
  }
}
