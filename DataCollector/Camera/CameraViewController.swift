//
//  CameraViewController.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import Foundation

import AVFoundation
import Combine
import SwiftUI

#if os(iOS)

    import UIKit

    class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
        let cmBufferSubject = PassthroughSubject<CMSampleBuffer, Never>()

        private var permissionGranted = false // Flag for permission
        private let captureSession = AVCaptureSession()
        private let sessionQueue = DispatchQueue(label: "sessionQueue")
        private var previewLayer = AVCaptureVideoPreviewLayer()
        var screenRect: CGRect! = nil // For view dimensions

        // Detector
        private var videoOutput = AVCaptureVideoDataOutput()

        var detectionLayer: CALayer? = nil

        var visionSubscriptions = Set<AnyCancellable>()

        override func viewDidLoad() {
            screenRect = UIScreen.main.bounds

            checkPermission()

            sessionQueue.async { [unowned self] in
                guard permissionGranted else { return }
                self.setupCaptureSession()

                self.setupDetector()

                self.captureSession.startRunning()
            }
        }

        override func willTransition(to _: UITraitCollection, with _: UIViewControllerTransitionCoordinator) {
            previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)

            switch UIDevice.current.orientation {
            // Home button on top
            case UIDeviceOrientation.portraitUpsideDown:
                previewLayer.connection?.videoOrientation = .portraitUpsideDown

            // Home button on right
            case UIDeviceOrientation.landscapeLeft:
                previewLayer.connection?.videoOrientation = .landscapeRight

            // Home button on left
            case UIDeviceOrientation.landscapeRight:
                previewLayer.connection?.videoOrientation = .landscapeLeft

            // Home button at bottom
            case UIDeviceOrientation.portrait:
                previewLayer.connection?.videoOrientation = .portrait

            default:
                break
            }

            // Detector
            updateLayers()
        }

        func checkPermission() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission has been granted before
            case .authorized:
                permissionGranted = true

            // Permission has not been requested yet
            case .notDetermined:
                requestPermission()

            default:
                permissionGranted = false
            }
        }

        func requestPermission() {
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                self.permissionGranted = granted
                self.sessionQueue.resume()
            }
        }

        private let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video, position: .unspecified)

        func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
            let devices = discoverySession.devices
            guard !devices.isEmpty else { fatalError("Missing capture devices.") }

            return devices.first(where: { device in device.position == position })!
        }

        func setupCaptureSession() {
            let videoDevice = bestDevice(in: .back)
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }

            guard captureSession.canAddInput(videoDeviceInput) else { return }
            captureSession.addInput(videoDeviceInput)

            // Preview layer
            screenRect = UIScreen.main.bounds

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
            previewLayer.connection?.videoOrientation = .portrait

            // Detector
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
            captureSession.addOutput(videoOutput)

            videoOutput.connection(with: .video)?.videoOrientation = .portrait

            // Updates to UI must be on main queue
            DispatchQueue.main.async { [weak self] in

                self!.view.layer.addSublayer(self!.previewLayer)

                self!.detectionLayer = CALayer()
                self!.detectionLayer!.frame = CGRect(x: 0, y: 0, width: self!.screenRect.size.width, height: self!.screenRect.size.height)
                self!.view.layer.addSublayer(self!.detectionLayer!)
            }
        }
    }

    struct HostedCameraViewController: UIViewControllerRepresentable {
        func makeUIViewController(context _: Context) -> UIViewController {
            return CameraViewController()
        }

        func updateUIViewController(_: UIViewController, context _: Context) {}
    }
#else

    import AppKit

    class CameraViewController: NSViewController {
        let cmBufferSubject = PassthroughSubject<CMSampleBuffer, Never>()
        var screenRect: CGRect! = nil // For view dimensions
        var detectionLayer: CALayer! = nil
    }
#endif
