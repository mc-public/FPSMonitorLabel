//
//  File.swift
//  
//
//  Created by 12345CPZ on 2023/6/26.
//

import Foundation
import UIKit
import FPSMonintor_Objc

/// FPSMonitor
@available(iOS 8.0.0, *) @objc
internal protocol FPSMonitorDelegate: AnyObject {
    func monitorDidUpdateFPS(_ monitor: FPSMonitor, framePreSecond: Float)
}


internal class FPSMonitor: NSObject {
    
    private weak var delegate: FPSMonitorDelegate?
    
    internal var updateFPSInternal: TimeInterval
    private var _displayLink: CADisplayLink?
    private var lastUpdateTime: TimeInterval
    private var delegateFlag = false
    
    private var count = 0
    
    
    
    override init() {
        lastUpdateTime = 0.0
        updateFPSInternal = 1.0
        super.init()
        
    }
    
    var displayLink: CADisplayLink {
        getDisplayLink()
    }
    func getDisplayLink() -> CADisplayLink {
        if let link = self._displayLink {
            return link
        }
        let target = WeakProxy(target: self)
        let link = CADisplayLink.init(target: target, selector: #selector(self.updateFPS(displayLink:)))
        self._displayLink = link
        if #available(iOS 15.0.0, *) {
            let model = UIDevice.current.model
            var minimumFramesPerSecond: Float = 10.0
            if model.contains("pad") || model.contains("Pad") || model.contains("PRO") {
                minimumFramesPerSecond = 24.0
            }
            let maximumFramesPerSecond = Float(UIScreen.main.maximumFramesPerSecond)
            link.preferredFrameRateRange = .init(minimum: minimumFramesPerSecond , maximum: maximumFramesPerSecond)
        } else if #available(iOS 10.0.0, *) {
            link.preferredFramesPerSecond = 60
        } else {
            link.frameInterval = 1
        }
        return link
    }
    
    
    func set(delegate: any FPSMonitorDelegate) {
        self.delegate = delegate
        if let delegate_obj = delegate as? (NSObject) {
            self.delegateFlag = delegate_obj.responds(to: #selector(delegate.monitorDidUpdateFPS(_:framePreSecond:)))
        }
    }
    
    func start() {
        if let _ = self._displayLink {
            return
        }
        self.displayLink.add(to: .current, forMode: .common)
    }
    
    func stop() {
        guard let displayLink = self._displayLink else {
            return
        }
        displayLink.invalidate()
        self._displayLink = nil
    }
    
    @objc func updateFPS(displayLink: CADisplayLink) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = displayLink.timestamp
        }
        count += 1
        let interval: TimeInterval = displayLink.timestamp - self.lastUpdateTime
        if interval < self.updateFPSInternal {
            return
        }
        lastUpdateTime = displayLink.timestamp
        let fps: Float = Float(count)/Float(interval)
        count = 0
        if delegateFlag {
            delegate?.monitorDidUpdateFPS(self, framePreSecond: fps)
        }
    }
    
    deinit {
        self.stop()
    }
    
}
