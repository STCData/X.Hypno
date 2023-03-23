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

class ObservingVisionWebView: WKWebView {
    private var subscriptions = Set<AnyCancellable>()

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    convenience init(observationPublisher: any Publisher<[VNObservation], Never>) {
        let conf = WKWebViewConfiguration()
        self.init(frame: CGRect.zero, configuration: conf)
        observationPublisher
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .map { $0.map { Observation.from(vnObservation: $0) } }
            .sink { observations in
                self.updateObservations(observations)

            }.store(in: &subscriptions)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateObservations(_ observations: [Observation]) {
        let observationsJson = try! observations.toJSON()
        evaluateJavaScript("\(JSUpdObs) ; updObs(\(observationsJson)) ; ") { result, error in
            if error == nil {
                print(result)
                print(result)
            } else {
                print(error)
                print(error)
            }
        }
    }
}

private let JSUpdObs = """
function updObs(observations) {
  const canvas = document.getElementById('my-canvas');
  if (canvas == null) { return } ;
  const ctx = canvas.getContext('2d');
  const label = `Observations: ${observations.length}`;
  const centerX = canvas.width / 2;
  const bottomY = canvas.height - 20;
  ctx.font = 'bold 20px Arial';
  ctx.textAlign = 'center';
  ctx.fillStyle = '#000000';
  ctx.clearRect(0, bottomY - 25, canvas.width, 25);
  ctx.fillText(label, centerX, bottomY);

return {
 "width": canvas.width,
 "height": canvas.height
}
}
"""
