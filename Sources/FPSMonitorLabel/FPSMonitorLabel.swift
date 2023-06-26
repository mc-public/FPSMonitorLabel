//
//  FPSMonitorLabel.swift
//  Butter
//
//  Created by 12345CPZ on 2023/6/26.
//

import SwiftUI
import FPSMonintor_Objc

/// A SwiftUI view with current FPS.
@available(iOS 13.0.0, *)
public struct FPSMonitorLabel: View {
    private var updateFPSInternal: TimeInterval
    
    /// Initializing a View that Can Display the Current Refresh Rate.
    ///
    /// - Parameter updateInternalConst: Update FPS Interval, the default value is `0.2` sec.
    ///
    /// After initializing this view, the current FPS value will be displayed immediately.
    public init(updateInternalConst: TimeInterval = 0.2) {
        self.updateFPSInternal = updateInternalConst
    }
    
    
    
    public var body: some View {
        ZStack(alignment: .center) {
            let label = _FPSMonitorLabel(updateTimeInternal: self.updateFPSInternal)
                .fixedSize()
            if #available(iOS 15.0.0, *) {
                label
                    .background {
                    Rectangle()
                        .fill(Color.yellow.opacity(0.4))
                }
            } else {
                label
                    .background(Color.yellow.opacity(0.4))
            }
        }
        
    }
}


@available(iOS 13.0.0, *)
private struct _FPSMonitorLabel: UIViewRepresentable {
    
    
    var timeInternal: TimeInterval
    var label: UIViewType
    
    
    init(updateTimeInternal: TimeInterval) {
        timeInternal = updateTimeInternal
        label = .init()
        label.updateFPSInternal = updateTimeInternal
        
    }
    
    func makeUIView(context: Context) -> FPSMonitorUILabel {
        label.updateFPSInternal = self.timeInternal
        label.font = .preferredMonospacedFont(for: .title2, weight: .medium)
        label.textColor = .green
        label.start()
        return label
    }
    
    func updateUIView(_ uiView: FPSMonitorUILabel, context: Context) {
        label.updateFPSInternal = self.timeInternal
    }
    
    typealias UIViewType = FPSMonitorUILabel
    
}

@available(iOS 13.0, *)
internal extension UIFont {
    
    /// 遵循动态类型的系统等宽字体配置。
    ///
    /// - Parameter style: 动态字体的文本风格。
    /// - Parameter weight: 动态字体的字重。
    ///
    /// 等宽字体不能调整字体宽度。
    static func preferredMonospacedFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.monospacedSystemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
