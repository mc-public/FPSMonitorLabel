//
//  File.swift
//  
//
//  Created by 12345CPZ on 2023/6/26.
//


import UIKit

@available(iOS 8.0.0, *)
/// View that Can Display the Current Refresh Rate.
public class FPSMonitorUILabel: UILabel, FPSMonitorDelegate {
    internal func monitorDidUpdateFPS(_ monitor: FPSMonitor, framePreSecond: Float) {
        self.text = NSString(format: "%d FPS", Int(round(framePreSecond)) ) as String
    }
    
    internal var fpsMonitor: FPSMonitor?
    
    /// Initializing a View that Can Display the Current Refresh Rate.
    ///
    /// After initializing this class, call the `start` method of this class to begin monitoring the current FPS.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initState()
    }
    
    /// Initializing a View that Can Display the Current Refresh Rate.
    ///
    /// After initializing this class, call the `start` method of this class to begin monitoring the current FPS.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initState()
    }
    
    
    /// Update FPS Interval, the default value is `0.2` sec.
    public var updateFPSInternal: TimeInterval = 0.2 {
        didSet {
            self.fpsMonitor?.updateFPSInternal = self.updateFPSInternal
        }
    }
    
    deinit {
        self.stop()
    }
    
    private func initState() {
        let label = self
        if #available(iOS 13.0, *) {
            label.font = .preferredMonospacedFont(for: .title2, weight: .medium)
        } else {
            // Fallback on earlier versions
            label.font = .boldSystemFont(ofSize: 12.0)
        }
        label.textColor = .green
        let monitor = FPSMonitor()
        monitor.set(delegate: self)
        self.fpsMonitor = monitor
        self.updateFPSInternal = 0.2
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// Starting to Monitor the Refresh Rate
    public func start() {
        self.fpsMonitor?.start()
    }
    /// Stopping the Refresh Rate Monitoring.
    public func stop() {
        self.fpsMonitor?.stop()
    }
    
    @objc private func appDidBecomeActive() {
        self.fpsMonitor?.start()
    }
    
    @objc private func appWillResignActive() {
        self.fpsMonitor?.stop()
    }
    
}

