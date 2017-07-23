//
//  Flags.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

public enum CouchbaseFlags: UInt32 {
  case NF_JSON = 0x00
  case NF_RAW = 0x02
  case NF_UTF8 = 0x04
  case NF_MASK = 0xFF
}

