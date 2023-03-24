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
        observationPublisher
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .map { $0.map { Observation.from($0, denormalizeFor: self.canvasSize) } }
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
        print(observationsJson)
        evaluateJavaScript("\(JSUpdObs) ; updObs(\(observationsJson)) ; ") { result, error in
            if error == nil {
                if let r = result as? [String: Any],
                   let width = r[JSOutputKeys.width.rawValue] as? CGFloat,
                   let height = r[JSOutputKeys.height.rawValue] as? CGFloat
                {
                    self.canvasSize = CGSize(width: width, height: height)
                }

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

function drawObservations(canvas, observations) {
  const ctx = canvas.getContext('2d');

  for (let obs of observations) {
    if (obs.bottomLeft && obs.bottomRight && obs.topLeft && obs.topRight) {
      // Draw a half-transparent rectangle
      ctx.fillStyle = 'rgba(255, 0, 0, 0.5)';
      ctx.fillRect(obs.bottomLeft.x, obs.bottomLeft.y, obs.bottomRight.x - obs.bottomLeft.x, obs.topLeft.y - obs.bottomLeft.y);
    }

    if (obs.recognizedPoints) {
      // Draw circles for each point
      for (let id in obs.recognizedPoints) {
        const point = obs.recognizedPoints[id];
        const x = point.x;
        const y = point.y;
        const r = 5;
        // Draw the circle
        ctx.beginPath();
        ctx.arc(x, y, r, 0, 2 * Math.PI, false);
        ctx.fillStyle = 'green';
        ctx.fill();
        // Draw the confidence and identifier next to the point
        if (point.confidence && point.identifier) {
          ctx.fillStyle = 'white';
          ctx.font = '12px sans-serif';
          ctx.fillText(`Confidence: ${point.confidence.toFixed(2)}, ID: ${point.identifier}`, x + r + 5, y);
        }
      }
    }
  }
}


function updObs(observations) {
  const canvas = document.getElementById('my-canvas');
  if (canvas == null) { return } ;

drawObservations(canvas, observations);
  const ctx = canvas.getContext('2d');
  const label =  `Observations: ${observations.length}`;
  const centerX = canvas.width / 2;
  const bottomY = canvas.height - 20;
  ctx.font = 'bold 29px Arial';
  ctx.textAlign = 'center';
  ctx.fillStyle = '#09f00066';
  ctx.clearRect(0, bottomY - 25, canvas.width, 25);
if (observations.length > 0) {
  ctx.fillText(label, centerX, bottomY);
}

return {
 "\(JSOutputKeys.width.rawValue)": canvas.width,
 "\(JSOutputKeys.height.rawValue)": canvas.height
}
}
"""
