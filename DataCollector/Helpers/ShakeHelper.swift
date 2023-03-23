//
//  ShakeHelper.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

#if os(iOS)

    import UIKit

    // The notification we'll send when a shake gesture happens.
    extension UIDevice {
        static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
    }

    //  Override the default behavior of shake gestures to send our notification instead.
    extension UIWindow {
        override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
            if motion == .motionShake {
                NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
            }
        }
    }

    // A view modifier that detects shaking and calls a function of our choosing.
    struct DeviceShakeViewModifier: ViewModifier {
        let action: () -> Void

        func body(content: Content) -> some View {
            content
                .onAppear()
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                    action()
                }
        }
    }

    // A View extension to make the modifier easier to use.
    extension View {
        func onShake(perform action: @escaping () -> Void) -> some View {
            modifier(DeviceShakeViewModifier(action: action))
        }
    }

#else

    struct DeviceShakeViewModifier: ViewModifier {
        let action: () -> Void

        func body(content: Content) -> some View {
            content
        }
    }

    // A View extension to make the modifier easier to use.
    extension View {
        func onShake(perform action: @escaping () -> Void) -> some View {
            modifier(DeviceShakeViewModifier(action: action))
        }
    }

#endif
