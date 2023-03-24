//
//  RTCConnectionState.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import Foundation
import WebRTC

extension RTCIceConnectionState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .new:          return "New"
        case .checking:     return "Checking"
        case .connected:    return "Connected"
        case .completed:    return "Completed"
        case .failed:       return "Failed"
        case .disconnected: return "Disconnected"
        case .closed:       return "Closed"
        case .count:        return "Count"
        @unknown default:   return "Unknown \(self.rawValue)"
        }
    }
    
    public var color: UIColor {
        switch self {
        case .new:          return .white
        case .checking:     return .white
        case .connected:    return .green
        case .completed:    return .blue
        case .failed:       return .red
        case .disconnected: return .orange
        case .closed:       return .orange
        case .count:        return .white
        @unknown default:   return .blue
        }
    }
}

extension RTCSignalingState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .stable:               return "stable"
        case .haveLocalOffer:       return "haveLocalOffer"
        case .haveLocalPrAnswer:    return "haveLocalPrAnswer"
        case .haveRemoteOffer:      return "haveRemoteOffer"
        case .haveRemotePrAnswer:   return "haveRemotePrAnswer"
        case .closed:               return "closed"
        @unknown default:   return "Unknown \(self.rawValue)"
        }
    }
}

extension RTCIceGatheringState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .new:          return "new"
        case .gathering:    return "gathering"
        case .complete:     return "complete"
        @unknown default:   return "Unknown \(self.rawValue)"
        }
    }
}

extension RTCDataChannelState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .connecting:   return "connecting"
        case .open:         return "open"
        case .closing:      return "closing"
        case .closed:       return "closed"
        @unknown default:   return "Unknown \(self.rawValue)"
        }
    }
}

enum RTCErrors: String,Error {
    case invalidURL             = "Can't create url"
    case unableToComplete       = "Unable the complete request.Please check your connection"
    case invalidResponse        = "Invalid response from the server.Please try again"
    case invalidData            = "The recevied data from server was invalid.Please try agin"
    case cannotEncodeSdp        = "Can not encode sdp."
    case cannotEncodeCandidate  = "Can not encode Candidate."
    case cannotSendSdp          = "Can not send SDP."
    case cannotSendCandidate    = "Can not send Candidate."
    case cannotGetAnswer        = "Can not get remote SDP."
    case cannotDecodeAnswer     = "Can not decode remote SDP."
    case cannotSetAnswer        = "Can not set remote SDP."
    case cannotGetCandidate     = "Can not get remote Candidate."
    case cannotDecodeCandidate  = "Can not decode remote Candidate."
    case cannotSetCandidate     = "Can not set remote Candidate."
    case unexpectedError        = "Unexpected error has occurred."
}
