//
//  CodeThumbnailView.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Runestone
import RunestoneSwiftUI
import SwiftUI
import TreeSitterJavaScriptRunestone
struct CodeView: View {
    @State
    var code: String

    var thumbnailed = false

    var body: some View {
        RunestoneSwiftUI.TextEditor(
            text: $code,
            theme: CodeTheme.shared,
            language: .javaScript, configuration: .init(isEditable: true, showLineNumbers: true), backgroundColor: UIColor.black
        )
        .autocorrectionDisabled(true)
        .themeFontSize(thumbnailed ? 4 : 9.7)
//        .frame(maxWidth: .infinity,
//               maxHeight: .infinity)

//        .frame(minHeight: 100, maxHeight: 600)

//        Text(code)
//            .font(.system(size: 5, design: .monospaced))
//            .minimumScaleFactor(0.09)
    }
}

struct CodeThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(code: "hello world")
    }
}
