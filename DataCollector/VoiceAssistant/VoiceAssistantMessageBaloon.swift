//
//  VoiceAssistantMessageBalloon.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import SwiftUI

struct VoiceAssistantMessageBalloon<Content: View>: View {
    let message: VAMessage

    let content: () -> Content

    var isFromCurrentUser: Bool {
        return message.role == .user || message.role == .userRecordingInProcess
    }

    let maxWidth: CGFloat = .infinity

    var body: some View {
        let backgroundColor: Color = {
            switch message.role {
            case .assistant:
                return Color.gray
            case .assistantCode:
                return Color.black
            case .user:
                return Color.blue
            case .userRecordingInProcess:
                return Color.pink
            case .userTyping:
                return Color.white.opacity(0.2)
            case .error:
                return Color.red
            }
        }()
        VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
            HStack {
                if !isFromCurrentUser {
                    Spacer()
                        .frame(width: 30, height: 30)
                }

                //            BalloonShape(isFromCurrentUser: isFromCurrentUser)
                //                .fill(backgroundColor)
                //                .overlay(
                HStack {
                    if message.role == .assistantCode {
                        CodeThumbnailView(code: message.text)
                    } else {
                        Text(message.text)
                            .foregroundColor(.white)
                        content()
                    }

                    if message.role == .userRecordingInProcess {
                        ProgressView()
                            .frame(width: 10, height: 10)
                    }

                }.padding(10)

                    .background(BalloonShape(isFromCurrentUser: isFromCurrentUser)
                        .fill(backgroundColor))
                    .padding(1)
                //                )

                if isFromCurrentUser {
                    Spacer()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.vertical, 1)
            .padding(.horizontal, 1)
            .opacity(0.4)
        }
        .frame(maxWidth: maxWidth, alignment: isFromCurrentUser ? .trailing : .leading)
    }
}

struct VoiceAssistantMessageBaloon_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAssistantMessageBalloon(message: VAMessage(text: "sample text", role: .user)) {
            Spacer()
        }
    }
}

struct BalloonShape: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        /*
         let width = rect.width
         let height = rect.height
         let radius: CGFloat = 10
         let tipWidth: CGFloat = 30

         // Draw balloon tail
         path.move(to: CGPoint(x: radius, y: height - radius))
         path.addLine(to: CGPoint(x: isFromCurrentUser ? width - tipWidth - radius : tipWidth + radius, y: height - radius))

         let center1 = CGPoint(x: isFromCurrentUser ? width - tipWidth - radius : tipWidth + radius, y: height - radius - radius)
         path.addArc(center: center1, radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: false)

         if !isFromCurrentUser {
             path.addLine(to: CGPoint(x: tipWidth + radius, y: radius))
         }

         // Draw balloon body
         let center2 = CGPoint(x: isFromCurrentUser ? width - tipWidth - radius : tipWidth + radius, y: radius + radius)
         path.addArc(center: center2, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: isFromCurrentUser ? -90 : 90), clockwise: false)
         path.addArc(center: CGPoint(x: isFromCurrentUser ? width - tipWidth - radius : tipWidth + radius, y: radius + radius), radius: radius, startAngle: Angle(degrees: isFromCurrentUser ? -90 : 90), endAngle: Angle(degrees: 0), clockwise: false)
         path.addLine(to: CGPoint(x: isFromCurrentUser ? width - radius : tipWidth + radius, y: height - radius))
         */
        return path
    }
}
