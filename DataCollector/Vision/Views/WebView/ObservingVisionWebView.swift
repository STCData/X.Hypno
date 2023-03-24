//
//  ObservingVisionWebView.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Combine
import Foundation
import Vision
import WebKit

enum JSOutputKeys: String {
    case height
    case width
}

class ObservingVisionWebView: WKWebView {
    private var subscriptions = Set<AnyCancellable>()

    private var canvasSize = CGSize.zero

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    convenience init(observationPublisher: any Publisher<[VNObservation], Never>) {
        let conf = WKWebViewConfiguration()
        self.init(frame: CGRect.zero, configuration: conf)
        let convertedObservationsArrayPublisher = observationPublisher
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .map { $0.map { Observation.from($0, denormalizeFor: self.canvasSize) } }

        let convertedFlatPublisher = convertedObservationsArrayPublisher
            .flatMap { observations in
                observations.publisher
            }
            .map { $0 as NaturalLanguageDescribable }
            .eraseToAnyPublisher()

        convertedFlatPublisher.subscribe(Describer.shared)

        convertedObservationsArrayPublisher
            .sink { observations in
                self.updateObservationsAndCanvasSize(observations)

            }.store(in: &subscriptions)

        VAAssistantShared().assistantCodeSubject
            .receive(on: RunLoop.main)
            .sink { code in
                self.evaluateJavaScript("""
                (function () {
                \(code) ;

                })()
                """) { result, error in
                    if error == nil {
                        print(result)
                        print(result)
                    } else {
                        print(error)
                        print(error)
                    }
                }
            }.store(in: &subscriptions)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func updateObservationsAndCanvasSize(_ observations: [Observation]) {
        let observationsJson = try! observations.toJSON()
        let updateJS = PromptJSGenerator.shared.updateJS(with: observationsJson)
        evaluateJavaScript(updateJS) { result, error in
            if error == nil {
                if let r = result as? [String: Any],
                   let width = r[JSOutputKeys.width.rawValue] as? CGFloat,
                   let height = r[JSOutputKeys.height.rawValue] as? CGFloat
                {
                    self.canvasSize = CGSize(width: width, height: height)
                }

                print(result)
            } else {
                print(error)
                print(error)
            }
        }
    }
}

extension WKWebView {
    func initJS() {
        evaluateJavaScript("\(PromptJSGenerator.shared.initJS) ; ") { result, error in
            if error == nil {
                print(result)
            } else {
                print(error)
            }
        }
    }
}
