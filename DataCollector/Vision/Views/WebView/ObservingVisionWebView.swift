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
        print(observationsJson)
        evaluateJavaScript("  \(JSUpdObs) ; updObs(\(observationsJson)) ; ") { result, error in
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
        evaluateJavaScript("\(JSInit) ; ") { result, error in
            if error == nil {
                print(result)
            } else {
                print(error)
            }
        }
    }
}

private let JSInit = """
function drawObservationsMarkers(canvas, observations) {
  const ctx = canvas.getContext('2d');

  // Clear the canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  for (let obs of observations) {

if (obs.bottomLeft && obs.bottomRight && obs.topLeft && obs.topRight) {
  // Draw a half-transparent rectangle
  ctx.fillStyle = 'rgba(233, 88, 0, 0.1)';
  ctx.fillRect(obs.bottomLeft.x, obs.bottomLeft.y, obs.bottomRight.x - obs.bottomLeft.x, obs.topLeft.y - obs.bottomLeft.y);

  // Add confidence and date in bottom left and bottom right respectively
  if (obs.confidence && obs.timestamp) {
    ctx.fillStyle = 'magent';
    ctx.font = '12px Arial';
    ctx.fillText(`🧠 ⏰`, obs.bottomRight.x - 7, obs.bottomRight.y + 15);
  }
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
          ctx.fillText(`🧠 ${point.confidence.toFixed(2)}, ID: ${point.identifier}`, x + r + 5, y);
        }
      }
    }
  }
}

function drawObservationsLabel(canvas, observations) {
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

}

function drawObservations(observations) {
  const canvas = document.getElementById('my-canvas');
  if (canvas == null) { return } ;

  drawObservationsMarkers(canvas, observations);
  drawObservationsLabel(canvas, observations);
}


window.addEventListener('\(VAMessage.JSObservationsEventName)', function(ev) {
    drawObservations(ev.detail.observations);
});


"""

private let JSUpdObs = """

function updObs(observations) {

const myEvent = new CustomEvent('\(VAMessage.JSObservationsEventName)', { detail: { observations: observations } });

window.dispatchEvent(myEvent);
//drawObservations(observations);

  const canvas = document.getElementById('my-canvas');
  if (canvas == null) { return } ;


    return {
     "\(JSOutputKeys.width.rawValue)": canvas.width,
     "\(JSOutputKeys.height.rawValue)": canvas.height
    }
}
"""
