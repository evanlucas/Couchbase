//
//  Request.swift
//  Couchbase
//
//  The JSONRepresentable and JSONSerializable both came from
//  https://gist.github.com/stinger/803299c1ee0c95e53dc3d9e59c37b187
//

import Foundation

public protocol JSONRepresentable {
  var JSONRepresentation: Any { get }
}

public protocol JSONSerializable: JSONRepresentable {}

public extension JSONSerializable {
  var JSONRepresentation: Any {
    var representation = [String: Any]()
    
    for case let (label?, value) in Mirror(reflecting: self).children {
      
      switch value {
        
      case let value as Dictionary<String, Any>:
        representation[label] = value as AnyObject
        
      case let value as Array<Any>:
        if let val = value as? [JSONSerializable] {
          representation[label] = val.map({ $0.JSONRepresentation as AnyObject }) as AnyObject
        } else {
          representation[label] = value as AnyObject
        }
        
      case let value:
        representation[label] = value as AnyObject
        
      default:
        // Ignore any unserializable properties
        break
      }
    }
    return representation as Any
  }
}

public extension JSONSerializable {
  func toJSON() -> String? {
    let representation = JSONRepresentation
    
    guard JSONSerialization.isValidJSONObject(representation) else {
      print("Invalid JSON Representation")
      return nil
    }
    
    do {
      let data = try JSONSerialization.data(withJSONObject: representation, options: [])
      
      return String(data: data, encoding: .utf8)
    } catch {
      return nil
    }
  }
}

// All documents should inherit from this
open class CBDocument: JSONSerializable {
  public init() {}
}

public struct CBDocumentInfo {
  public var key: String
  public var expiry: UInt32 = 0
  public var cas: UInt64?
  public var doc: CBDocument
  public var flags: CouchbaseFlags = .NF_JSON
  
  public init(key: String, doc: CBDocument) {
    self.key = key
    self.doc = doc
  }
}
