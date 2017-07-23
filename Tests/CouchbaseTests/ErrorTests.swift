//
//  ErrorTests.swift
//  CouchbaseTests
//
//  Created by Evan Lucas on 7/23/17.
//

import Foundation
import XCTest
@testable import Couchbase

class ECase {
  let code: CouchbaseErrorCode
  let str: String

  init(code: CouchbaseErrorCode, str: String) {
    self.code = code
    self.str = str
  }
}

class ErrorTests: XCTestCase {
  static let allTests = [
    ("testErrors", testErrors)
  ]

  func testErrors() {
    let cases = [
      ECase(code: .EAUTHCONTINUE, str: "EAUTHCONTINUE")
    , ECase(code: .EAUTHCONTINUE, str: "EAUTHCONTINUE")
    , ECase(code: .EAUTH, str: "EAUTH")
    , ECase(code: .EDELTABADVAL, str: "EDELTABADVAL")
    , ECase(code: .E2BIG, str: "E2BIG")
    , ECase(code: .EBUSY, str: "EBUSY")
    , ECase(code: .EINTERNAL, str: "EINTERNAL")
    , ECase(code: .EINVAL, str: "EINVAL")
    , ECase(code: .ENOMEM, str: "ENOMEM")
    , ECase(code: .ERANGE, str: "ERANGE")
    , ECase(code: .EGENERIC, str: "EGENERIC")
    , ECase(code: .ETMPFAIL, str: "ETMPFAIL")
    , ECase(code: .EEXIST, str: "EEXIST")
    , ECase(code: .ENOENT, str: "ENOENT")
    , ECase(code: .EDLOPEN, str: "EDLOPEN")
    , ECase(code: .EDLSYM, str: "EDLSYM")
    , ECase(code: .ENETWORK, str: "ENETWORK")
    , ECase(code: .ENOTMYVBUCKET, str: "ENOTMYVBUCKET")
    , ECase(code: .ENOTSTORED, str: "ENOTSTORED")
    , ECase(code: .ENOTSUPPORTED, str: "ENOTSUPPORTED")
    , ECase(code: .EUNKNOWNCOMMAND, str: "EUNKNOWNCOMMAND")
    , ECase(code: .EUNKNOWNHOST, str: "EUNKNOWNHOST")
    , ECase(code: .EPROTOCOLERROR, str: "EPROTOCOLERROR")
    , ECase(code: .ETIMEDOUT, str: "ETIMEDOUT")
    , ECase(code: .ECONNECTERROR, str: "ECONNECTERROR")
    , ECase(code: .EBUCKETENOENT, str: "EBUCKETENOENT")
    , ECase(code: .ECLIENTNOMEM, str: "ECLIENTNOMEM")
    , ECase(code: .ECLIENTENOCONF, str: "ECLIENTENOCONF")
    , ECase(code: .EEBADHANDLE, str: "EEBADHANDLE")
    , ECase(code: .ESERVERBUG, str: "ESERVERBUG")
    , ECase(code: .EPLUGINVERSIONMISMATCH, str: "EPLUGINVERSIONMISMATCH")
    , ECase(code: .EINVALIDHOSTFORMAT, str: "EINVALIDHOSTFORMAT")
    , ECase(code: .EINVALIDCHAR, str: "EINVALIDCHAR")
    , ECase(code: .EDURABILITYETOOMANY, str: "EDURABILITYETOOMANY")
    , ECase(code: .EDUPLICATECOMMANDS, str: "EDUPLICATECOMMANDS")
    , ECase(code: .ENOMATCHINGSERVER, str: "ENOMATCHINGSERVER")
    , ECase(code: .EBADENVIRONMENT, str: "EBADENVIRONMENT")
    , ECase(code: .EBUSYINTERNAL, str: "EBUSYINTERNAL")
    , ECase(code: .EINVALIDUSERNAME, str: "EINVALIDUSERNAME")
    , ECase(code: .ECONFIGCACHEINVALID, str: "ECONFIGCACHEINVALID")
    , ECase(code: .ESASLMECHUNAVAILABLE, str: "ESASLMECHUNAVAILABLE")
    , ECase(code: .ETOOMANYREDIRECTS, str: "ETOOMANYREDIRECTS")
    , ECase(code: .EMAPCHANGED, str: "EMAPCHANGED")
    , ECase(code: .EINCOMPLETE_PACKET, str: "EINCOMPLETE_PACKET")
    , ECase(code: .EECONNREFUSED, str: "EECONNREFUSED")
    , ECase(code: .EESOCKSHUTDOWN, str: "EESOCKSHUTDOWN")
    , ECase(code: .EECONNRESET, str: "EECONNRESET")
    , ECase(code: .EECANTGETPORT, str: "EECANTGETPORT")
    , ECase(code: .EEFDLIMITREACHED, str: "EEFDLIMITREACHED")
    , ECase(code: .EENETUNREACH, str: "EENETUNREACH")
    , ECase(code: .EECTLUNKNOWN, str: "EECTLUNKNOWN")
    , ECase(code: .EECTLUNSUPPMODE, str: "EECTLUNSUPPMODE")
    , ECase(code: .EECTLBADARG, str: "EECTLBADARG")
    , ECase(code: .EEMPTYKEY, str: "EEMPTYKEY")
    , ECase(code: .ESSL, str: "ESSL")
    , ECase(code: .ESSLCANTVERIFY, str: "ESSLCANTVERIFY")
    , ECase(code: .ESCHEDFAILINTERNAL, str: "ESCHEDFAILINTERNAL")
    , ECase(code: .ECLIENTFEATUREUNAVAILABLE, str: "ECLIENTFEATUREUNAVAILABLE")
    , ECase(code: .EOPTIONSCONFLICT, str: "EOPTIONSCONFLICT")
    , ECase(code: .EHTTP, str: "EHTTP")
    , ECase(code: .EDURABILITYNOMUTATIONTOKENS, str: "EDURABILITYNOMUTATIONTOKENS")
    , ECase(code: .EUNKNOWNMEMCACHED, str: "EUNKNOWNMEMCACHED")
    , ECase(code: .EMUTATIONLOST, str: "EMUTATIONLOST")
    , ECase(code: .ESUBDOCPATHENOENT, str: "ESUBDOCPATHENOENT")
    , ECase(code: .ESUBDOCPATHMISMATCH, str: "ESUBDOCPATHMISMATCH")
    , ECase(code: .ESUBDOCPATHEINVAL, str: "ESUBDOCPATHEINVAL")
    , ECase(code: .ESUBDOCPATHE2BIG, str: "ESUBDOCPATHE2BIG")
    , ECase(code: .ESUBDOCDOCE2DEEP, str: "ESUBDOCDOCE2DEEP")
    , ECase(code: .ESUBDOCVALUECANTINSERT, str: "ESUBDOCVALUECANTINSERT")
    , ECase(code: .ESUBDOCDOCNOTJSON, str: "ESUBDOCDOCNOTJSON")
    , ECase(code: .ESUBDOCNUMERANGE, str: "ESUBDOCNUMERANGE")
    , ECase(code: .ESUBDOCBADDELTA, str: "ESUBDOCBADDELTA")
    , ECase(code: .ESUBDOCPATHEEXISTS, str: "ESUBDOCPATHEEXISTS")
    , ECase(code: .ESUBDOCMULTIFAILURE, str: "ESUBDOCMULTIFAILURE")
    , ECase(code: .ESUBDOCVALUEE2DEEP, str: "ESUBDOCVALUEE2DEEP")
    , ECase(code: .EEINVALMCD, str: "EEINVALMCD")
    , ECase(code: .EEMPTYPATH, str: "EEMPTYPATH")
    , ECase(code: .EUNKNOWNSDCMD, str: "EUNKNOWNSDCMD")
    , ECase(code: .EENOCOMMANDS, str: "EENOCOMMANDS")
    , ECase(code: .EQUERY, str: "EQUERY")
    , ECase(code: .EGENERICTMPERR, str: "EGENERICTMPERR")
    , ECase(code: .EGENERICSUBDOCERR, str: "EGENERICSUBDOCERR")
    , ECase(code: .EGENERICCONSTRAINTERR, str: "EGENERICCONSTRAINTERR")
    , ECase(code: .ENAMESERVER, str: "ENAMESERVER")
    , ECase(code: .ENOTAUTHORIZED, str: "ENOTAUTHORIZED")
    , ECase(code: .EINVALIDJSON, str: "EINVALIDJSON")
    ]

    for item in cases {
      XCTAssertEqual(item.code.toString(), item.str)
    }
  }
}
