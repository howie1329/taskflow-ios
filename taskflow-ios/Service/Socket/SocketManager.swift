//
//  SocketManager.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 8/12/25.
//

import SocketIO
import Foundation

@Observable
class TaskFlowSocketManager {
    static let shared = TaskFlowSocketManager()
    
    let manager: SocketManager
    let socket: SocketIOClient
    var isConnected: Bool = false
    
    // MARK: - Initialization
    init(serverURL: String = "http://localhost:3001") {
        manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(true), .compress, .extraHeaders(["userid": "user_2usb0Md2SjCvMehu1XHJBN2y03c"])])
        socket = manager.defaultSocket
        setupSocketEvents()
        self.connect()
    }
    
    private func setupSocketEvents() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("socket connected")
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("socket disconnected")
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }

        socket.on(clientEvent: .reconnect) { [weak self] data, ack in
            print("socket reconnected")
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
        isConnected = false
    }
    
    func emit(event: String, data: [String: Any]) {
        socket.emit(event, data)
    }
    
    
    func on(event: String, callback: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket.on(event, callback: callback)
    }
}
