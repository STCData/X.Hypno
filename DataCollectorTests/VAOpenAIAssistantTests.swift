//
//  VAOpenAIAssistantTests.swift
//  DataCollectorTests
//
//  Created by standard on 3/24/23.
//

import XCTest
@testable
import DataCollector
import OpenAISwift

final class VAOpenAIAssistantTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testParsing() throws {
        let two = VAMessage.parseAssistantMessages(from: """
        bla bla
        \(VAMessage.JSStartMarker)
        js1.1
        js1.2
        js1.3
        \(VAMessage.JSEndMarker)

        """)

        let two2 = VAMessage.parseAssistantMessages(from: """
        bla bla
        \(VAMessage.JSStartMarker)
        js1.1
        js1.2
        js1.3
        \(VAMessage.JSEndMarker)
        """)
        let two3 = VAMessage.parseAssistantMessages(from: "bla bla\n\(VAMessage.JSStartMarker)\njs1.1\njs1.2\njs1.3\n\(VAMessage.JSEndMarker)"
        )

        let three1 = VAMessage.parseAssistantMessages(from: """
        bla bla
        \(VAMessage.JSStartMarker)
        js1.1
        js1.2
        js1.3
        \(VAMessage.JSEndMarker)
        bla bla
        """)

        let three2 = VAMessage.parseAssistantMessages(from: """
        bla bla
        \(VAMessage.JSStartMarker)
        js1.1
        js1.2
        js1.3
        \(VAMessage.JSEndMarker)

        bla bla
        """)

        XCTAssertEqual(two.count, 2)
        XCTAssertEqual(two2.count, 2)
        XCTAssertEqual(two3.count, 2)
        XCTAssertEqual(three1.count, 3)
        XCTAssertEqual(three2.count, 3)

        XCTAssertEqual(two.map { $0.text }, ["bla bla\n", "js1.1\njs1.2\njs1.3\n"])

        XCTAssertEqual(roles(two), [.assistant, .assistantCode])
        XCTAssertEqual(roles(two2), [.assistant, .assistantCode])
        XCTAssertEqual(roles(two3), [.assistant, .assistantCode])
        XCTAssertEqual(roles(three1), [.assistant, .assistantCode, .assistant])
        XCTAssertEqual(roles(three2), [.assistant, .assistantCode, .assistant])

        let five = VAMessage.parseAssistantMessages(from: """
        bla bla
        \(VAMessage.JSStartMarker)
        js1.1
        js1.2
        js1.3
        \(VAMessage.JSEndMarker)

        bla bla

        \(VAMessage.JSStartMarker)
        js2.1
        js2.2
        js2.3
        \(VAMessage.JSEndMarker)

        bla bla2

        """)
        XCTAssertEqual(roles(five), [.assistant, .assistantCode, .assistant, .assistantCode, .assistant])

        XCTAssertEqual(five.map { $0.text }, ["bla bla\n", "js1.1\njs1.2\njs1.3\n", "bla bla\n", "js2.1\njs2.2\njs2.3\n", "bla bla2\n"])

        let one = VAMessage.parseAssistantMessages(from: "\(VAMessage.JSStartMarker)\nconst canvas = document.getElementById(\'my-canvas\');\nconst ctx = canvas.getContext(\'2d\');\n\nconst centerX = canvas.width / 2;\nconst centerY = canvas.height / 2;\nconst width = canvas.width;\nconst height = canvas.height;\n\nctx.lineWidth = 5;\nctx.strokeStyle = \"#FF0000\";\nctx.fillStyle = \"#FF0000\";\nctx.beginPath();\nctx.moveTo(centerX, centerY - height/4);\nctx.bezierCurveTo(centerX + width/4, centerY - height/2, centerX + width/2, centerY - height/4, centerX, centerY + height/2);\nctx.bezierCurveTo(centerX - width/2, centerY - height/4, centerX - width/4, centerY - height/2, centerX, centerY - height/4);\nctx.stroke();\nctx.fill();\n\(VAMessage.JSEndMarker)")

        XCTAssertEqual(roles(one), [.assistantCode])

        let apologies = VAMessage.parseAssistantMessages(from: "Apologies for that! Here is an updated code that would draw the markers on each observation, considering fingers:\n\n```\nwindow.addEventListener(\'onObservationsUpdate\', function(ev) {\n  const canvas = document.getElementById(\'my-canvas\');\n  const ctx = canvas.getContext(\'2d\');\n  // Clear canvas\n  ctx.clearRect(0, 0, canvas.width, canvas.height);\n  const observations = ev.detail.observations;\n  // For each observation, draw a circle marker\n  observations.forEach(observation => {\n    // Set marker color based on type of observation\n    const color = (observation.recognizedPoints ? \'blue\' : \'green\');\n    ctx.fillStyle = color;\n    if (observation.recognizedPoints) {\n      // For finger point observation, draw a small circle at each finger position\n      Object.values(observation.recognizedPoints).forEach(fingerPos => {\n        ctx.beginPath();\n        ctx.arc(fingerPos.x, fingerPos.y, 3, 0, 2*Math.PI);\n        ctx.fill();\n      });\n    } else {\n      // For text observation, draw a larger circle at the center of the bounding box\n      const position = Object.values(observation.boundingBox[0]);\n      ctx.beginPath();\n      ctx.arc(position[0], position[1], 10, 0, 2*Math.PI);\n      ctx.fill();\n    }\n  });\n});\n\n```\n")

        XCTAssertEqual(roles(apologies), [.assistant, .assistantCode])
    }

    func roles(_ messages: [VAMessage]) -> [VAMessageRole] {
        return messages.map { $0.role }
    }
}
