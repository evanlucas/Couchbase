//
//  BucketTests.swift
//  CouchbaseTests
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation
import XCTest
@testable import Couchbase

public class Doc: CBDocument {
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
  , ("testGetPass", testGetPass)
  , ("testGetNoCallbackPass", testGetNoCallbackPass)
  , ("testGetNoCallbackFail", testGetNoCallbackFail)
  , ("testInsertFail", testInsertFail)
  ]
  
  var bucket: Bucket!
  
  func testConnectFail() throws {
    bucket = Bucket(uri: "couchbases://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    var passed = true
    do {
      try bucket.connect()
    } catch {
      guard let er = error as? CouchbaseError else {
        XCTFail("Should have been a CouchbaseError")
        return
      }
      
      XCTAssertEqual(er.code, CouchbaseErrorCode.ENETWORK)
      passed = false
    }

    XCTAssertEqual(passed, false, "connect should have thrown error")
  }
  
  func testConnectPass() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
  }
  
  func testInsertFail() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    
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
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
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

  func testGetNoCallbackPass() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    bucket.get(key: "123456", cb: nil)
  }

  func testGetNoCallbackFail() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    bucket.get(key: "fasdfasdf", cb: nil)
  }

  func testGetPass() throws {
    bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    bucket.get(key: "123456") { (err, res) in
      XCTAssertNil(err)

      guard let res = res as? GetResponse else {
        XCTFail("Unable to convert res to GetResponse")
        return
      }
      XCTAssertEqual(res.key, "123456")

      guard let doc = res.doc as? [String: Any] else {
        XCTFail("Unable to extract doc")
        return
      }

      guard let name = doc["name"] as? String else {
        XCTFail("Unable to extract name")
        return
      }

      XCTAssertEqual(name, "test")
    }
  }
}
