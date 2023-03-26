//
//  VADummyAssistant.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Combine
import Foundation

struct VADummyAssistant: VAAssistant {
    var assistantGUIAutomateSubject: AnyPublisher<String, Never>? = nil

    var assistantBrowserAutomateSubject: AnyPublisher<String, Never>? = nil

    var assistantBashCodeSubject: AnyPublisher<String, Never>? = nil

    static let shared = VADummyAssistant()

    private init() {}

    var assistantCodeSubject: AnyPublisher<String, Never>? {
        return passthroughCodeSubject.eraseToAnyPublisher()
    }

    let passthroughCodeSubject = PassthroughSubject<String, Never>()

    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage] {
        let userMessage = VAMessage(text: message, role: .user)
        let assistantResponce = Float.random(in: 0.0 ... 1.0) > 0.9 ? VAMessage(text: "bot said: '\(message)'", role: .assistant) : VAMessage(text: JSDummy[
//            0
            Int.random(in: 0 ..< JSDummy.count)
        ], role: .assistantCode)

        if assistantResponce.role == .assistantCode {
            passthroughCodeSubject.send(assistantResponce.text)
        }

        return chat + [userMessage, assistantResponce]
    }
}

private let JSDummy = [
    """
     const canvas = document.getElementById('my-canvas');
     const ctx = canvas.getContext('2d');

     const kittenImg = new Image();
     kittenImg.crossOrigin = 'anonymous';
     kittenImg.src = 'https://source.unsplash.com/400x400/?kitten';

     kittenImg.onload = () => {
       ctx.drawImage(kittenImg, canvas.width/2 - kittenImg.width/2, canvas.height/2 - kittenImg.height/2);

       setTimeout(() => {
         ctx.clearRect(0, 0, canvas.width, canvas.height);
       }, 1500);
     }
    """,

    """
    const canvas = document.getElementById('my-canvas');
    const ctx = canvas.getContext('2d');

    const gradient = ctx.createRadialGradient(canvas.width/2, canvas.height/2, 0, canvas.width/2, canvas.height/2, 100);
    gradient.addColorStop(0, 'rgba(255, 0, 0, 0.5)');
    gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');

    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(canvas.width/2, canvas.height/2, 100, 0, 2*Math.PI);
    ctx.fill();

    setTimeout(() => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }, 1500);



    """,

    """

    const canvas = document.getElementById('my-canvas');
    const ctx = canvas.getContext('2d');

    for (let i = 0; i < 50; i++) {
      const x = Math.random() * canvas.width;
      const y = Math.random() * canvas.height;
      const radius = Math.random() * 50;
      const hue = Math.random() * 360;
      ctx.fillStyle = `hsla(${hue}, 100%, 50%, 0.5)`;
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, 2*Math.PI);
      ctx.fill();
    }

    setTimeout(() => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }, 1500);


    """,

    """
    const canvas = document.getElementById('my-canvas');
    const ctx = canvas.getContext('2d');

    const gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
    gradient.addColorStop(0, 'red');
    gradient.addColorStop(1, 'blue');

    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.moveTo(100, 100);
    ctx.lineTo(130, 170);
    ctx.lineTo(200, 180);
    ctx.lineTo(145, 225);
    ctx.lineTo(160, 295);
    ctx.lineTo(100, 255);
    ctx.lineTo(40, 295);
    ctx.lineTo(55, 225);
    ctx.lineTo(0, 180);
    ctx.lineTo(70, 170);
    ctx.closePath();
    ctx.fill();

    setTimeout(() => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }, 1500);

    """,

    """
    const canvas = document.getElementById('my-canvas');
    const ctx = canvas.getContext('2d');

    let hue = 0;
    let radius = 1;
    let angle = 0;

    ctx.lineWidth = 2;
    ctx.strokeStyle = `hsl(${hue}, 100%, 50%)`;

    ctx.beginPath();
    ctx.moveTo(canvas.width/2, canvas.height/2);

    for (let i = 0; i < 1000; i++) {
      hue += 0.1;
      if (hue >= 360) {
        hue = 0;
      }
      radius += 0.05;
      angle += 0.1;
      const x = canvas.width/2 + radius * Math.cos(angle);
      const y = canvas.height/2 + radius * Math.sin(angle);
      ctx.strokeStyle = `hsl(${hue}, 100%, 50%)`;
      ctx.lineTo(x, y);
    }

    ctx.stroke();

    setTimeout(() => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }, 1500);

    """,
]
