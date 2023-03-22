//
//  StreamViewModel.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//
import Combine
import SwiftUI
import ARKit
import WebRTC
import FirebaseFirestore

final class StreamViewModel:NSObject, ObservableObject {
    var mapStatus = CurrentValueSubject<ARFrame.WorldMappingStatus,Never>(.notAvailable)
    var isLightingSufficient = CurrentValueSubject<Bool,Never>(false)
    let db = Firestore.firestore()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    var isOfferSended = false
    
    var webRTCClient = WebRTCClient()
    @Published var connectionStatus = "Not connected"
    var remoteCandidateCount = 0
    var localCandidateCount = 0
    @Published var hasRemoteSdp = false
    
    private var cancellable = Set<AnyCancellable>()
    let scan: Scan
    @Published var isScanning = true
    
    init(scan: Scan) {
        self.scan = scan
        super.init()
        self.webRTCClient.delegate = self
        db.collection("calls").document("candidate").collection("candidates").getDocuments { snap, err in
            snap?.documents.forEach { $0.reference.delete() }
        }
        db.collection("calls").document("candidate").collection("answerCandidates").getDocuments { snap, err in
            snap?.documents.forEach { $0.reference.delete() }
        }
        db.collection("calls").document("candidate").collection("offerCandidates").getDocuments { snap, err in
            snap?.documents.forEach { $0.reference.delete() }
        }
        db.collection("calls").document("offer").delete()
        db.collection("calls").document("answer").delete()
        db.collection("users").document(UserDefaults.userId!).setData(["offers" : [""],"answers": [""]])
        listenSdp()
    }
    
    func sendOffer() {
        self.webRTCClient.offer { [weak self] (rtcSdp) in
            guard let self = self else { return }
            let dataMessage = try! self.encoder.encode(SessionDescription(from: rtcSdp))
            let dict = try! JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
            self.db.collection("calls").document("offer").setData(dict) { (err) in
                if let err = err {
                    print("Error send sdp: \(err)")
                } else {
                    print("Sdp sent!")
                }
            }
        }
    }
    
    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        let dataMessage = try! self.encoder.encode(IceCandidate(from: rtcIceCandidate))
        let dict = try! JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
        db.collection("calls")
            .document("candidate")
            .collection("offerCandidates")
            .addDocument(data: dict) { (err) in
                if let err = err {
                    print("Error send candidate: \(err)")
                } else {
                    print("Candidate sent!")
                }
            }
    }
    
    func listenSdp() {
        db.collection("calls").document("answer")
            .addSnapshotListener { documentSnapshot, error in
                guard self.isOfferSended else { return }
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    print("Error fetching sdp: \(String(describing: error))")
                    return
                }
                let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let sessionDescription = try! self.decoder.decode(SessionDescription.self, from: jsonData)
                self.webRTCClient.set(remoteSdp: sessionDescription.rtcSessionDescription) { (error) in
                    self.hasRemoteSdp = true
                }
            }
        
        db.collection("calls")
            .document("candidate")
            .collection("answerCandidates")
            .addSnapshotListener { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(err!)")
                    return
                }
                
                querySnapshot!.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let jsonData = try! JSONSerialization.data(withJSONObject: documents.first!.data(), options: .prettyPrinted)
                        let iceCandidate = try! self.decoder.decode(IceCandidate.self, from: jsonData)
                        self.webRTCClient.set(remoteCandidate: iceCandidate.rtcIceCandidate) { error in
                            print("Received remote candidate")
                            self.remoteCandidateCount += 1
                        }
                    }
                }
            }
    }
    
    func doneTapped() {
        self.isScanning = false
    }
}

extension StreamViewModel: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        self.localCandidateCount += 1
        self.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        print(state.self)
        DispatchQueue.main.async {
            self.connectionStatus = state.description.capitalized
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) { }
}
