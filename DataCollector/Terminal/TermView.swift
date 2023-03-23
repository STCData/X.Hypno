//
//  TermView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

#if os(iOS)

    struct HostedTerminalViewController: UIViewControllerRepresentable {
        func makeUIViewController(context _: Context) -> UIViewController {
            return TerminalViewController()
        }

        func updateUIViewController(_: UIViewController, context _: Context) {}
    }
#endif

struct TermView: View {
    var body: some View {
        #if os(iOS)

            HostedTerminalViewController()
        #else
            Spacer()
        #endif
    }
}
