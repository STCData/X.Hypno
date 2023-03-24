//
//  CodeThumbnailView.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import SwiftUI

struct CodeThumbnailView: View {
    let code: String
    var body: some View {
        Text(code)
            .font(.system(size: 5, design: .monospaced))
            .minimumScaleFactor(0.09)
    }
}

struct CodeThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        CodeThumbnailView(code: "hello world")
    }
}
