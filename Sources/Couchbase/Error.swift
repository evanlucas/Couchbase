//
//  Error.swift
//  Couchbase
//
//  Created by Evan Lucas on 7/22/17.
//

import Foundation
import Libcouchbase

func makeCouchbaseError(err: lcb_error_t) -> CouchbaseError {
  let msg: String = err.toString()
  let code: CouchbaseErrorCode = CouchbaseErrorCode(rawValue: err.rawValue)!
  
  return CouchbaseError(code: code, description: msg)
}

public struct CouchbaseError: Error, CustomStringConvertible {
  public var code: CouchbaseErrorCode
  public var description: String
}

public enum CouchbaseErrorCode: UInt32 {
  case EAUTHCONTINUE = 0x01
  case EAUTH = 0x02
  case EDELTABADVAL = 0x03
  case E2BIG = 0x04
  case EBUSY = 0x05
  case EINTERNAL = 0x06
  case EINVAL = 0x07
  case ENOMEM = 0x08
  case ERANGE = 0x09
  case EGENERIC = 0x0a
  case ETMPFAIL = 0x0b
  case EEXIST = 0x0c
  case ENOENT = 0x0d
  case EDLOPEN = 0x0e
  case EDLSYM = 0x0f
  case ENETWORK = 0x10
  case ENOTMYVBUCKET = 0x11
  case ENOTSTORED = 0x12
  case ENOTSUPPORTED = 0x13
  case EUNKNOWNCOMMAND = 0x14
  case EUNKNOWNHOST = 0x15
  case EPROTOCOLERROR = 0x16
  case ETIMEDOUT = 0x17
  case ECONNECTERROR = 0x18
  case EBUCKETENOENT = 0x19
  case ECLIENTNOMEM = 0x1a
  case ECLIENTENOCONF = 0x1B
  case EEBADHANDLE = 0x1C
  case ESERVERBUG = 0x1D
  case EPLUGINVERSIONMISMATCH = 0x1E
  case EINVALIDHOSTFORMAT = 0x1F
  case EINVALIDCHAR = 0x20
  case EDURABILITYETOOMANY = 0x21
  case EDUPLICATECOMMANDS = 0x22
  case ENOMATCHINGSERVER = 0x23
  case EBADENVIRONMENT = 0x24
  case EBUSYINTERNAL = 0x25
  case EINVALIDUSERNAME = 0x26
  case ECONFIGCACHEINVALID = 0x27
  case ESASLMECHUNAVAILABLE = 0x28
  case ETOOMANYREDIRECTS = 0x29
  case EMAPCHANGED = 0x2A
  case EINCOMPLETE_PACKET = 0x2B
  case EECONNREFUSED = 0x2C
  case EESOCKSHUTDOWN = 0x2D
  case EECONNRESET = 0x2E
  case EECANTGETPORT = 0x2F
  case EEFDLIMITREACHED = 0x30
  case EENETUNREACH = 0x31
  case EECTLUNKNOWN = 0x32
  case EECTLUNSUPPMODE = 0x33
  case EECTLBADARG = 0x34
  case EEMPTYKEY = 0x35
  case ESSL = 0x36
  case ESSLCANTVERIFY = 0x37
  case ESCHEDFAILINTERNAL = 0x38
  case ECLIENTFEATUREUNAVAILABLE = 0x39
  case EOPTIONSCONFLICT = 0x3A
  case EHTTP = 0x3B
  case EDURABILITYNOMUTATIONTOKENS = 0x3C
  case EUNKNOWNMEMCACHED = 0x3D
  case EMUTATIONLOST = 0x3E
  case ESUBDOCPATHENOENT = 0x3F
  case ESUBDOCPATHMISMATCH = 0x40
  case ESUBDOCPATHEINVAL = 0x41
  case ESUBDOCPATHE2BIG = 0x42
  case ESUBDOCDOCE2DEEP = 0x43
  case ESUBDOCVALUECANTINSERT = 0x44
  case ESUBDOCDOCNOTJSON = 0x45
  case ESUBDOCNUMERANGE = 0x46
  case ESUBDOCBADDELTA = 0x47
  case ESUBDOCPATHEEXISTS = 0x48
  case ESUBDOCMULTIFAILURE = 0x49
  case ESUBDOCVALUEE2DEEP = 0x4A
  case EEINVALMCD = 0x4B
  case EEMPTYPATH = 0x4C
  case EUNKNOWNSDCMD = 0x4D
  case EENOCOMMANDS = 0x4E
  case EQUERY = 0x4F
  case EGENERICTMPERR = 0x50
  case EGENERICSUBDOCERR = 0x51
  case EGENERICCONSTRAINTERR = 0x52
  case ENAMESERVER = 0x53
  case ENOTAUTHORIZED = 0x54
  
  case EINVALIDJSON = 0x88
}

extension CouchbaseErrorCode {
  public func toString() -> String {
    switch self {
    case .EAUTHCONTINUE:
      return "EAUTHCONTINUE"
    case .EAUTH:
      return "EAUTH"
    case .EDELTABADVAL:
      return "EDELTABADVAL"
    case .E2BIG:
      return "E2BIG"
    case .EBUSY:
      return "EBUSY"
    case .EINTERNAL:
      return "EINTERNAL"
    case .EINVAL:
      return "EINVAL"
    case .ENOMEM:
      return "ENOMEM"
    case .ERANGE:
      return "ERANGE"
    case .EGENERIC:
      return "EGENERIC"
    case .ETMPFAIL:
      return "ETMPFAIL"
    case .EEXIST:
      return "EEXIST"
    case .ENOENT:
      return "ENOENT"
    case .EDLOPEN:
      return "EDLOPEN"
    case .EDLSYM:
      return "EDLSYM"
    case .ENETWORK:
      return "ENETWORK"
    case .ENOTMYVBUCKET:
      return "ENOTMYVBUCKET"
    case .ENOTSTORED:
      return "ENOTSTORED"
    case .ENOTSUPPORTED:
      return "ENOTSUPPORTED"
    case .EUNKNOWNCOMMAND:
      return "EUNKNOWNCOMMAND"
    case .EUNKNOWNHOST:
      return "EUNKNOWNHOST"
    case .EPROTOCOLERROR:
      return "EPROTOCOLERROR"
    case .ETIMEDOUT:
      return "ETIMEDOUT"
    case .ECONNECTERROR:
      return "ECONNECTERROR"
    case .EBUCKETENOENT:
      return "EBUCKETENOENT"
    case .ECLIENTNOMEM:
      return "ECLIENTNOMEM"
    case .ECLIENTENOCONF:
      return "ECLIENTENOCONF"
    case .EEBADHANDLE:
      return "EEBADHANDLE"
    case .ESERVERBUG:
      return "ESERVERBUG"
    case .EPLUGINVERSIONMISMATCH:
      return "EPLUGINVERSIONMISMATCH"
    case .EINVALIDHOSTFORMAT:
      return "EINVALIDHOSTFORMAT"
    case .EINVALIDCHAR:
      return "EINVALIDCHAR"
    case .EDURABILITYETOOMANY:
      return "EDURABILITYETOOMANY"
    case .EDUPLICATECOMMANDS:
      return "EDUPLICATECOMMANDS"
    case .ENOMATCHINGSERVER:
      return "ENOMATCHINGSERVER"
    case .EBADENVIRONMENT:
      return "EBADENVIRONMENT"
    case .EBUSYINTERNAL:
      return "EBUSYINTERNAL"
    case .EINVALIDUSERNAME:
      return "EINVALIDUSERNAME"
    case .ECONFIGCACHEINVALID:
      return "ECONFIGCACHEINVALID"
    case .ESASLMECHUNAVAILABLE:
      return "ESASLMECHUNAVAILABLE"
    case .ETOOMANYREDIRECTS:
      return "ETOOMANYREDIRECTS"
    case .EMAPCHANGED:
      return "EMAPCHANGED"
    case .EINCOMPLETE_PACKET:
      return "EINCOMPLETE_PACKET"
    case .EECONNREFUSED:
      return "EECONNREFUSED"
    case .EESOCKSHUTDOWN:
      return "EESOCKSHUTDOWN"
    case .EECONNRESET:
      return "EECONNRESET"
    case .EECANTGETPORT:
      return "EECANTGETPORT"
    case .EEFDLIMITREACHED:
      return "EEFDLIMITREACHED"
    case .EENETUNREACH:
      return "EENETUNREACH"
    case .EECTLUNKNOWN:
      return "EECTLUNKNOWN"
    case .EECTLUNSUPPMODE:
      return "EECTLUNSUPPMODE"
    case .EECTLBADARG:
      return "EECTLBADARG"
    case .EEMPTYKEY:
      return "EEMPTYKEY"
    case .ESSL:
      return "ESSL"
    case .ESSLCANTVERIFY:
      return "ESSLCANTVERIFY"
    case .ESCHEDFAILINTERNAL:
      return "ESCHEDFAILINTERNAL"
    case .ECLIENTFEATUREUNAVAILABLE:
      return "ECLIENTFEATUREUNAVAILABLE"
    case .EOPTIONSCONFLICT:
      return "EOPTIONSCONFLICT"
    case .EHTTP:
      return "EHTTP"
    case .EDURABILITYNOMUTATIONTOKENS:
      return "EDURABILITYNOMUTATIONTOKENS"
    case .EUNKNOWNMEMCACHED:
      return "EUNKNOWNMEMCACHED"
    case .EMUTATIONLOST:
      return "EMUTATIONLOST"
    case .ESUBDOCPATHENOENT:
      return "ESUBDOCPATHENOENT"
    case .ESUBDOCPATHMISMATCH:
      return "ESUBDOCPATHMISMATCH"
    case .ESUBDOCPATHEINVAL:
      return "ESUBDOCPATHEINVAL"
    case .ESUBDOCPATHE2BIG:
      return "ESUBDOCPATHE2BIG"
    case .ESUBDOCDOCE2DEEP:
      return "ESUBDOCDOCE2DEEP"
    case .ESUBDOCVALUECANTINSERT:
      return "ESUBDOCVALUECANTINSERT"
    case .ESUBDOCDOCNOTJSON:
      return "ESUBDOCDOCNOTJSON"
    case .ESUBDOCNUMERANGE:
      return "ESUBDOCNUMERANGE"
    case .ESUBDOCBADDELTA:
      return "ESUBDOCBADDELTA"
    case .ESUBDOCPATHEEXISTS:
      return "ESUBDOCPATHEEXISTS"
    case .ESUBDOCMULTIFAILURE:
      return "ESUBDOCMULTIFAILURE"
    case .ESUBDOCVALUEE2DEEP:
      return "ESUBDOCVALUEE2DEEP"
    case .EEINVALMCD:
      return "EEINVALMCD"
    case .EEMPTYPATH:
      return "EEMPTYPATH"
    case .EUNKNOWNSDCMD:
      return "EUNKNOWNSDCMD"
    case .EENOCOMMANDS:
      return "EENOCOMMANDS"
    case .EQUERY:
      return "EQUERY"
    case .EGENERICTMPERR:
      return "EGENERICTMPERR"
    case .EGENERICSUBDOCERR:
      return "EGENERICSUBDOCERR"
    case .EGENERICCONSTRAINTERR:
      return "EGENERICCONSTRAINTERR"
    case .ENAMESERVER:
      return "ENAMESERVER"
    case .ENOTAUTHORIZED:
      return "ENOTAUTHORIZED"
    case .EINVALIDJSON:
      return "EINVALIDJSON"
    }
  }
}
