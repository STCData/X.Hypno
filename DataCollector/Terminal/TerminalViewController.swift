//
//  TerminalViewController.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftTerm
#if os(iOS)

    import UIKit

    class TerminalViewController: UIViewController {
        var tv: TerminalView!
        var transparent: Bool = false

        var useAutoLayout: Bool { true }

//    var t: Timer?

        func makeFrame(keyboardDelta: CGFloat, _: String = #function, _: Int = #line) -> CGRect {
            if useAutoLayout {
                return CGRect.zero
            } else {
                return CGRect(x: view.safeAreaInsets.left,
                              y: view.safeAreaInsets.top,
                              width: view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right,
                              height: view.frame.height - view.safeAreaInsets.top - keyboardDelta)
            }
        }

        func setupConstrains() {
            if #available(iOS 15.0, *), useAutoLayout {
                tv.translatesAutoresizingMaskIntoConstraints = false
                tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

//            tv.keyboardLayoutGuide.topAnchor.constraint(equalTo: tv.bottomAnchor).isActive = true
            }
        }

        func setupKeyboardMonitor() {
            if #available(iOS 15.0, *), useAutoLayout {
                tv.translatesAutoresizingMaskIntoConstraints = false
                tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

                tv.keyboardLayoutGuide.topAnchor.constraint(equalTo: tv.bottomAnchor).isActive = true
            } else {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillShow),
                    name: UIWindow.keyboardWillShowNotification,
                    object: nil
                )
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillHide),
                    name: UIWindow.keyboardWillHideNotification,
                    object: nil
                )
            }
        }

        var keyboardDelta: CGFloat = 0
        @objc private func keyboardWillShow(_ notification: NSNotification) {
            guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            keyboardDelta = keyboardViewEndFrame.height
            tv.frame = makeFrame(keyboardDelta: keyboardViewEndFrame.height)
        }

        override func viewWillTransition(to size: CGSize, with _: UIViewControllerTransitionCoordinator) {
            tv.frame = CGRect(origin: tv.frame.origin, size: size)
        }

        @objc private func keyboardWillHide(_: NSNotification) {
            // let key = UIResponder.keyboardFrameBeginUserInfoKey
            keyboardDelta = 0
            tv.frame = makeFrame(keyboardDelta: 0)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

//
//        t = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
//            self.tv.feed(text: "...\n\r")
//        }

            // Do any additional setup after loading the view, typically from a nib.

            tv = TerminalView(frame: makeFrame(keyboardDelta: 0))

            tv.isOpaque = false
            tv.backgroundColor = UIColor.clear
            tv.nativeBackgroundColor = UIColor.clear

            view.addSubview(tv)
            setupConstrains()
//        setupKeyboardMonitor()
//        tv.becomeFirstResponder()
            NotificationCenter.default.addObserver(self, selector: #selector(handleTermLogUpdate(_:)), name: Notification.Name.TermLogNotification, object: nil)
        }

        @objc func handleTermLogUpdate(_ notification: Notification) {
            if let updatedTermLog = notification.userInfo?[TermLogNotificationUserInfoLogString] as? String {
                let text = "\(updatedTermLog)\n\r"
                DispatchQueue.main.async {
                    self.tv.feed(text: text)
                    if self.tv.canScroll {
                        self.tv.scroll(toPosition: 20)
                    }
                }
            }
        }

        override func viewWillLayoutSubviews() {
            if useAutoLayout, #available(iOS 15.0, *) {
            } else {
                tv.frame = makeFrame(keyboardDelta: keyboardDelta)
            }
            if transparent {
                tv.backgroundColor = UIColor.clear
            }
        }
    }

#else

    import AppKit

    class TerminalViewController: NSViewController {}
#endif
