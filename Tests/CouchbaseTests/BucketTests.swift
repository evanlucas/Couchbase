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
  , ("testInsert", testInsert)
  , ("testGet", testGet)
  , ("testRemove", testRemove)
  , ("testGetNoCallbackPass", testGetNoCallbackPass)
  , ("testGetNoCallbackFail", testGetNoCallbackFail)
  ]

  func getId() -> String {
    return UUID().uuidString.lowercased()
  }
  
  func testConnectFail() throws {
    let bucket = Bucket(uri: "couchbases://localhost/migrations")
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
    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
  }

  func testInsert() throws {
    let expect = expectation(description: "bucket.insert() pass")
    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    try bucket.connect()
    defer {
      bucket.disconnect()
    }
    let key = getId()

    func insertPass() {
      let doc: Doc = Doc(name: "test")
      let info: CBDocumentInfo = CBDocumentInfo(key: key, doc: doc)
      bucket.insert(doc: info) { (err, res) in
        XCTAssertNil(err)
        let res = res as! StoreResponse
        XCTAssertEqual(res.key, key, "key is on the response")
        insertAgain()
      }
    }

    func insertAgain() {
      let doc: Doc = Doc(name: "test")
      let info2: CBDocumentInfo = CBDocumentInfo(key: key, doc: doc)
      bucket.insert(doc: info2, cb: { (err, res) in
        XCTAssertNotNil(err)
        expect.fulfill()
        if err != nil {
          let er = err as! CouchbaseError

          XCTAssertEqual(er.code,
                         CouchbaseErrorCode.EEXIST,
                         "Error code is EEXIST")
        }
      })
    }

    insertPass()
    waitForExpectations(timeout: 10) { (err) in
      XCTAssertNil(err)
    }
  }

  func testGet() throws {
    let pass = expectation(description: "bucket.get() pass")
    let fail = expectation(description: "bucket.get() fail")

    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    try bucket.connect()
    defer {
      bucket.disconnect()
    }
    let key = getId()

    bucket.get(key: getId()) { (err, res) in
      XCTAssertNotNil(err)

      if err != nil {
        let er = err as! CouchbaseError

        XCTAssertEqual(er.code,
                       CouchbaseErrorCode.ENOENT,
                       "Error code is ENOENT")
        fail.fulfill()
      }
    }

    let doc: Doc = Doc(name: "test")
    let info: CBDocumentInfo = CBDocumentInfo(key: key, doc: doc)
    bucket.insert(doc: info) { (err, res) in
      XCTAssertNil(err)

      bucket.get(key: key, cb: { (err, res) in
        XCTAssertNil(err)

        if res != nil {
          let res = res as! GetResponse
          XCTAssertEqual(res.key, key)

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

        pass.fulfill()
      })
    }

    waitForExpectations(timeout: 10) { (err) in
      XCTAssertNil(err)
    }
  }

  func testGetNoCallbackPass() throws {
    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    bucket.get(key: "123456", cb: nil)
  }

  func testGetNoCallbackFail() throws {
    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()
    bucket.get(key: "fasdfasdf", cb: nil)
  }

  func testRemove() throws {
    let pass = expectation(description: "bucket.remove() pass")
    let fail = expectation(description: "bucket.remove() fail")
    let bucket = Bucket(uri: "couchbase://localhost/migrations")
    defer {
      bucket.disconnect()
    }
    try bucket.connect()

    let key = getId()

    bucket.remove(key: getId()) { (err, res) in
      XCTAssertNotNil(err)

      if err != nil {
        let er = err as! CouchbaseError

        XCTAssertEqual(er.code,
                       CouchbaseErrorCode.ENOENT,
                       "Error code is ENOENT")
        fail.fulfill()
      }
    }

    let doc: Doc = Doc(name: "test")
    let info: CBDocumentInfo = CBDocumentInfo(key: key, doc: doc)
    bucket.insert(doc: info) { (err, res) in
      XCTAssertNil(err)

      bucket.remove(key: key, cb: { (err, res) in
        XCTAssertNil(err)

        if res != nil {
          let res = res as! RemoveResponse
          XCTAssertEqual(res.key, key)
        }

        pass.fulfill()
      })
    }

    waitForExpectations(timeout: 10) { (err) in
      XCTAssertNil(err)
    }
  }
}
