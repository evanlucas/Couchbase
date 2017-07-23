//
//  Extensions.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation
import Libcouchbase

extension lcb_error_t {
  func toString() -> String {
    let memory: UnsafePointer<Int8> = lcb_strerror(nil, self)
    return String(cString: memory)
  }
}
