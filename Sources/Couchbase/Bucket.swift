//
//  Bucket.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation
import Libcouchbase

public typealias Callback = (Error?, Any?) -> Void

public class Bucket {
  let uri: String
  var instance: lcb_t? = nil
  var ops = [UUID: Callback]()
  
  public init(uri: String) {
    self.uri = uri
  }
  
  public func connect() throws {
    var crst: lcb_create_st = lcb_create_st()
    crst.version = 3
    self.uri.withCString({ cstr in
      crst.v.v3.connstr = cstr
    })
    
    lcb_create(&self.instance, &crst)
    self.setupCallbacks()
    var rc: lcb_error_t = lcb_connect(self.instance)
    if rc != LCB_SUCCESS {
      throw makeCouchbaseError(err: rc)
    }
    
    lcb_wait(instance)
    
    rc = lcb_get_bootstrap_status(instance)
    if rc != LCB_SUCCESS {
      throw makeCouchbaseError(err: rc)
    }
    
    let context = UnsafeMutableRawPointer(
      Unmanaged.passUnretained(self).toOpaque()
    )
    lcb_set_cookie(self.instance, context)
  }
  
  func setupCallbacks() {
    lcb_set_bootstrap_callback(self.instance) { (instance, rc) in
      // print("bootstrapped")
    }
    
    lcb_set_get_callback(self.instance) { (instance, cookie, error, resp) in
      if let cookie = cookie {
        let cval = lcb_get_cookie(instance)
        let this = Unmanaged<Bucket>.fromOpaque(cval!).takeUnretainedValue()
        this.dispatchValueCallback(instance: instance,
                                   cookie: cookie,
                                   error: error,
                                   resp: resp)
      }
    }
    
    lcb_set_store_callback(self.instance) { (instance, cookie, storage, error, resp) in
      if let cookie = cookie {
        let cval = lcb_get_cookie(instance)
        let this = Unmanaged<Bucket>.fromOpaque(cval!).takeUnretainedValue()
        this.dispatchStoreCallback(instance: instance,
                                   cookie: cookie,
                                   error: error,
                                   resp: resp)
      }
    }

    lcb_set_remove_callback(self.instance) { (instance, cookie, error, resp) in
      if let cookie = cookie {
        let cval = lcb_get_cookie(instance)
        let this = Unmanaged<Bucket>.fromOpaque(cval!).takeUnretainedValue()
        this.dispatchRemoveCallback(instance: instance,
                                    cookie: cookie,
                                    error: error,
                                    resp: resp)
      }
    }
  }
  
  func dispatchValueCallback(instance: lcb_t?,
                             cookie: UnsafeRawPointer?,
                             error: lcb_error_t,
                             resp: UnsafePointer<lcb_get_resp_t>?) {
    guard let cook: UnsafeRawPointer = cookie else {
      return
    }

    let c: Cookie = Unmanaged<Cookie>.fromOpaque(cook).takeRetainedValue()
    
    guard let fn: Callback = self.ops.removeValue(forKey: c.id) else {
      return
    }
    
    let res: lcb_get_resp_t = resp![0]
    
    if error != LCB_SUCCESS {
      fn(makeCouchbaseError(err: error), nil)
      return
    }
    
    let bytes = res.v.v0.bytes
    let nbytes = res.v.v0.nbytes
    let flags = res.v.v0.flags
    let cas = res.v.v0.cas
    let doc = self.decodeDoc(bytes: bytes!, nbytes: nbytes, flags: flags)
    
    let out: GetResponse = GetResponse(cas: cas, key: c.key, doc: doc)
    fn(nil, out)
  }
  
  func dispatchStoreCallback(instance: lcb_t?,
                             cookie: UnsafeRawPointer?,
                             error: lcb_error_t,
                             resp: UnsafePointer<lcb_store_resp_t>?) {
    guard let cook: UnsafeRawPointer = cookie else {
      return
    }
    
    let c: Cookie = Unmanaged<Cookie>.fromOpaque(cook).takeRetainedValue()
    
    guard let fn: Callback = self.ops.removeValue(forKey: c.id) else {
      return
    }
    
    let res: lcb_store_resp_t = resp![0]
    
    if error != LCB_SUCCESS {
      fn(makeCouchbaseError(err: error), nil)
      return
    }
    
    let cas = res.v.v0.cas
    
    let out: StoreResponse = StoreResponse(cas: cas, key: c.key)
    fn(nil, out)
  }

  func dispatchRemoveCallback(instance: lcb_t?,
                              cookie: UnsafeRawPointer?,
                              error: lcb_error_t,
                              resp: UnsafePointer<lcb_remove_resp_t>?) {
    guard let cook: UnsafeRawPointer = cookie else {
      return
    }

    let c: Cookie = Unmanaged<Cookie>.fromOpaque(cook).takeRetainedValue()

    guard let fn: Callback = self.ops.removeValue(forKey: c.id) else {
      return
    }

    let res: lcb_remove_resp_t = resp![0]

    if error != LCB_SUCCESS {
      fn(makeCouchbaseError(err: error), nil)
      return
    }

    let cas = res.v.v0.cas

    let out: RemoveResponse = RemoveResponse(cas: cas, key: c.key)
    fn(nil, out)
  }
  
  func decodeDoc(bytes: UnsafeRawPointer, nbytes: Int, flags: UInt32) -> Any {
    let format: CouchbaseFlags = CouchbaseFlags(rawValue: flags & UInt32(0xFF))!
    let data: Data = Data(bytes: bytes, count: nbytes)
    if format == .NF_JSON {
      do {
        let json = try JSONSerialization.jsonObject(with: data,
                                                    options: .allowFragments)
        return json
      } catch {
        return String(data: data, encoding: .utf8) as Any
      }
    }
    
    return String(data: data, encoding: .utf8) as Any
  }
  
  public func get(key: String, cb: Callback?) {
    var cmd: lcb_CMDGET = lcb_CMDGET()
    cmd.key.type = LCB_KV_COPY
    cmd.key.contig.nbytes = key.lengthOfBytes(using: .utf8)
    let data = key.data(using: .utf8)! as NSData
    cmd.key.contig.bytes = data.bytes
    
    let id = UUID()
    if cb != nil {
      self.ops[id] = cb
    }
    
    let cookie: Cookie = Cookie(id: id, key: key)
    let context = UnsafeMutableRawPointer(
      Unmanaged.passRetained(cookie).toOpaque()
    )
    let rc: lcb_error_t = lcb_get3(instance, context, &cmd)
    if rc != LCB_SUCCESS {
      if cb != nil {
        cb!(makeCouchbaseError(err: rc), nil)
      }
      return
    }
    
    lcb_wait(self.instance)
  }
  
  public func insert(doc: CBDocumentInfo, cb: Callback?) {
    self.store(doc: doc, operation: LCB_ADD, cb: cb)
  }
  
  public func upsert(doc: CBDocumentInfo, cb: Callback?) {
    self.store(doc: doc, operation: LCB_SET, cb: cb)
  }
  
  public func replace(doc: CBDocumentInfo, cb: Callback?) {
    self.store(doc: doc, operation: LCB_REPLACE, cb: cb)
  }

  public func remove(key: String, cb: Callback?) {
    var cmd: lcb_CMDREMOVE = lcb_CMDREMOVE()
    cmd.key.type = LCB_KV_COPY
    cmd.key.contig.nbytes = key.lengthOfBytes(using: .utf8)
    let data = key.data(using: .utf8)! as NSData
    cmd.key.contig.bytes = data.bytes

    let id = UUID()
    if cb != nil {
      self.ops[id] = cb
    }

    let cookie: Cookie = Cookie(id: id, key: key)
    let context = UnsafeMutableRawPointer(
      Unmanaged.passRetained(cookie).toOpaque()
    )
    let rc: lcb_error_t = lcb_remove3(instance, context, &cmd)
    if rc != LCB_SUCCESS {
      if cb != nil {
        cb!(makeCouchbaseError(err: rc), nil)
      }
      return
    }

    lcb_wait(self.instance)
  }
  
  func store(doc: CBDocumentInfo, operation: lcb_storage_t, cb: Callback?) {
    var cmd: lcb_CMDSTORE = lcb_CMDSTORE()
    cmd.key.type = LCB_KV_COPY
    cmd.key.contig.nbytes = doc.key.lengthOfBytes(using: .utf8)
    let key_data = doc.key.data(using: .utf8)! as NSData
    cmd.key.contig.bytes = key_data.bytes
    cmd.operation = operation
    
    guard let json = doc.doc.toJSON() else {
      if cb != nil {
        let er: CouchbaseError = CouchbaseError(code: .EINVALIDJSON,
                                                description: "Invalid json provided")
        cb!(er, nil)
      }
      return
    }
    
    cmd.value.u_buf.contig.nbytes = json.lengthOfBytes(using: .utf8)
    let val_data = json.data(using: .utf8)! as NSData
    cmd.value.u_buf.contig.bytes = val_data.bytes
    
    if doc.cas != nil {
      cmd.cas = doc.cas!
    }
    
    if doc.expiry != 0 {
      cmd.exptime = doc.expiry
    }
    
    let id = UUID()
    if cb != nil {
      self.ops[id] = cb
    }
    
    let cookie: Cookie = Cookie(id: id, key: doc.key)
    let context = UnsafeMutableRawPointer(
      Unmanaged.passRetained(cookie).toOpaque()
    )
    
    let rc: lcb_error_t = lcb_store3(instance, context, &cmd)
    if rc != LCB_SUCCESS {
      if cb != nil {
        cb!(makeCouchbaseError(err: rc), nil)
      }
      return
    }
    
    lcb_wait(self.instance)
  }
  
  public func disconnect() {
    lcb_destroy(self.instance)
  }
}
