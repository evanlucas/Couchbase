//
//  BucketTests.swift
//  CouchbaseTests
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation
import XCTest
import Couchbase

class Doc: CBDocument {
  var name: String
  
  init(name: String) {
    self.name = name
    super.init()
  }
}

class BucketTests: XCTestCase {
  static let allTests = [
    ("testConnectFail", testConnectFail)
  , ("testConnectPass", testConnectPass)
  , ("testGetFail", testGetFail)
  ]
  
  var bucket: Bucket!
  
  func testConnectFail() throws {
    bucket = Bucket(uri: "couchbases://localhost/migrations")
    var passed = true
    do {
      try bucket.connect()
      defer {
        bucket.disconnect()
      }
    } catch {
      guard let er = error as? CouchbaseError else {
        XCTFail("Should have been a CouchbaseError")
        return
      }
      
      XCTAssertEqual(er.code, CouchbaseErrorCode.ENETWORK)
      passed = false
    }
    
    if passed == true {
      XCTFail("connect should have thrown an error, but did not")
    }
  }
  
  func testConnectPass() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    try bucket.connect()
    defer {
      bucket.disconnect()
    }
  }
  
  func testInsertFail() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    try bucket.connect()
    defer {
      bucket.disconnect()
    }
    
    let doc: Doc = Doc(name: "test")
    let info: CBDocumentInfo = CBDocumentInfo(key: "123456", doc: doc)
    bucket.insert(doc: info) { (err, res) in
      if err == nil {
        XCTFail("Expected an error to be returned")
        return
      }
      
      guard let er = err as? CouchbaseError else {
        XCTFail("Should have been a CouchbaseError")
        return
      }
      
      XCTAssertEqual(er.code,
                     CouchbaseErrorCode.EEXIST,
                     "Error code is EEXIST")
    }
  }
  
  func testGetFail() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    try bucket.connect()
    defer {
      bucket.disconnect()
    }
    bucket.get(key: "fasdfasdf") { (err, doc) in
      if err == nil {
        XCTFail("expected to get error from GET")
        return
      }
      
      guard let error = err as? CouchbaseError else {
        XCTFail("expected to get a CouchbaseError")
        return
      }
      
      XCTAssertEqual(error.code,
                     CouchbaseErrorCode.ENOENT,
                     "Error code is ENOENT")
    }
  }
}
