//
//  TermView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct HostedTerminalViewController: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UIViewController {
        return TerminalViewController()
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

struct TermView: View {
    var body: some View {
        HostedTerminalViewController()
    }
}
