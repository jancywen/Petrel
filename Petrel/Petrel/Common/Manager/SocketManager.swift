//
//  SocketManager.swift
//  Demo
//
//  Created by captain on 2020/11/24.
//  Copyright © 2020 captain. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

class SocketManager {
    
    var socket: WebSocket?
    var isConnected: Bool = false
    var isManualDisConnected: Bool = false
    var isManualUnsub: Bool = false
    var timer: Timer?

    
    // 回调
    var didConnected:(() -> Void)?
    var didReceive: ((Data)-> Void)?
    
    
    // 单例
    static var defaultManager: SocketManager {
        struct Single {
            static let defaultManager = SocketManager()
        }
        return Single.defaultManager
    }
    
    /// 连接
    public func startConnect() {
        var request = URLRequest(url: URL(string: "wss://www.gx.com/ws/market/comp/echo")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
//        socket?.callbackQueue = DispatchQueue(label: "starscream.app")
        socket?.delegate = self
        socket?.connect()
    }
    /// 定时器连接
    @objc private func reconnectTimer() {
        print("重新连接......")
        self.startConnect()
    }
    
    /// 断开
    public func disConnect() {
        isManualDisConnected = true
        handleDisconnect()
        
        socket?.disconnect()
        socket = nil
    }
    /// 自动断开
    private func automaticDisconnect() {
        isManualDisConnected = false
        socket?.disconnect()
        socket = nil
    }

    /// write
    public func write(_ data: Data) {
        guard isConnected else {
            return
        }
        socket?.write(data: data)
    }
        
    private func handleDisconnect() {
        isConnected = false
        if isManualDisConnected {
            if self.timer != nil {
                self.timer?.invalidate()
                self.timer = nil
            }
        }else {
            automaticDisconnect()
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reconnectTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    private func handleConnected() {
        isConnected = true
        self.timer?.invalidate()
        self.timer = nil
        
        didConnected?()
    }
}


extension SocketManager:WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            handleConnected()
        case .disconnected(_, _):
            handleDisconnect()
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            didReceive?(data)
        case .ping(_):
            break
        case .pong(_):
            print("pong")
            break
        case .viabilityChanged(let status):
            if !status {
                handleDisconnect()
            }
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            handleDisconnect()
            print("cancel connect")
        case .error(_):
            isConnected = false

        }
    }
}
