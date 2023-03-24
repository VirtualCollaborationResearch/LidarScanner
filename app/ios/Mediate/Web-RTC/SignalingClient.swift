//
//  SignalClient.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import Foundation
import WebRTC
import FirebaseFirestore
import Combine

final class SignalingClient:NSObject {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let db = Firestore.firestore()
    private var hasRemoteSdp = false
    private var hasLocalSdp = false
    private var webRTCClient = WebRTCClient()
    private var remoteCandidateCount = 0
    private var localCandidateCount = 0
    private let collection = "calls"
    
    var connectionState = PassthroughSubject<RTCIceConnectionState,Never>()
    var errorState = PassthroughSubject<RTCErrors,Never>()

    override init() {
        super.init()
        webRTCClient.delegate = self
        db.collection(collection).document("candidate").collection("answerCandidates").getDocuments { snap, err in
            snap?.documents.forEach { $0.reference.delete() }
        }
        db.collection(collection).document("candidate").collection("offerCandidates").getDocuments { snap, err in
            snap?.documents.forEach { $0.reference.delete() }
        }
        db.collection(collection).document("answer").delete()
        db.collection(collection).document("offer").delete()
        listenAnswer()
    }
    
    func send(data:Data) {
        webRTCClient.sendData(data)
    }
    
    private func sendError(_ error:RTCErrors) {
        DispatchQueue.main.async { [weak self] in
            self?.errorState.send(error)
        }
    }
    
    func sendOffer() {
        webRTCClient.offer { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self?.webRTCClient.offer { [weak self] sdp in
                    self?.send(sdp: sdp)
                }
            }
        }
    }
    
    private func send(sdp rtcSdp: RTCSessionDescription) {
        if let dataMessage = try? encoder.encode(SessionDescription(from: rtcSdp)),
           let dict = try? JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as? [String: Any] {
            db.collection(collection).document("offer").setData(dict) { [weak self] (err) in
                if let err = err {
                    print("Error send sdp: \(err)")
                    self?.sendError(.cannotSendSdp)
                } else {
                    self?.hasLocalSdp = true
                    print("Sdp sent!")
                }
            }
        } else {
            sendError(.cannotEncodeSdp)
        }
    }
    
    private func send(candidate rtcIceCandidate: RTCIceCandidate) {
        if let dataMessage = try? encoder.encode(IceCandidate(from: rtcIceCandidate)),
           let dict = try? JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as? [String: Any] {
            db.collection(collection)
                .document("candidate")
                .collection("offerCandidates")
                .addDocument(data: dict) { [weak self] (err) in
                    if let err = err {
                        print("Error send candidate: \(err)")
                        self?.sendError(.cannotSendCandidate)
                    } else {
                        print("Candidate sent!,path:")
                    }
                }
        } else {
            sendError(.cannotEncodeCandidate)
        }
    }
    
    private func listenAnswer() {
        db.collection(collection).document("answer")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    print("Error fetching sdp: \(String(describing: error))")
                    self?.sendError(.cannotGetAnswer)
                    return
                }
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                   let sessionDescription = try? self?.decoder.decode(SessionDescription.self, from: jsonData) {
                    self?.webRTCClient.set(remoteSdp: sessionDescription.rtcSessionDescription) { [weak self] (error) in
                        if error == nil {
                            self?.hasRemoteSdp = true
                        } else {
                            self?.sendError(.cannotSetAnswer)
                        }
                    }
                } else {
                    self?.sendError(.cannotDecodeAnswer)
                }
            }
        
        db.collection(collection)
            .document("candidate")
            .collection("answerCandidates")
            .addSnapshotListener { [weak self] (querySnapshot, err) in
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("Error fetching candidates: \(String(describing: err))")
                    self?.sendError(.cannotGetCandidate)
                    return
                }
                
                querySnapshot?.documentChanges.forEach { [weak self] diff in
                    if (diff.type == .added) {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: documents.first!.data(), options: .prettyPrinted),
                           let iceCandidate = try? self?.decoder.decode(IceCandidate.self, from: jsonData) {
                            self?.webRTCClient.set(remoteCandidate: iceCandidate.rtcIceCandidate) { [weak self] error in
                                if error == nil {
                                    self?.remoteCandidateCount += 1
                                } else {
                                    self?.sendError(.cannotSetCandidate)
                                }
                            }
                        } else {
                            self?.sendError(.cannotDecodeCandidate)
                        }
                    }
                }
            }
    }
}

extension SignalingClient: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        self.localCandidateCount += 1
        self.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        DispatchQueue.main.async { [weak self] in
            self?.connectionState.send(state)
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) { }
}

