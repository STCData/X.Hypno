//
//  VoiceAssistantMessageBalloon.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import SwiftUI

struct VoiceAssistantMessageBalloon<Content: View>: View {
    @State private var isCodeFullScreen = false

    let message: VAMessage

    let content: () -> Content

    var isFromCurrentUser: Bool {
        return message.role == .user || message.role == .userRecordingInProcess || message.role == .userExpectingResponse || message.role == .userTyping
    }

    let maxWidth: CGFloat = .infinity

    var body: some View {
        let backgroundColor: Color = {
            switch message.role {
            case .assistant:
                return Color.gray
            case .assistantCode:
                return Color.black
            case .assistantClientSideService:
                return Color.gray.opacity(0.6)
            case .user:
                return Color.blue
            case .userRecordingInProcess:
                return Color.pink
            case .userExpectingResponse:
                return Color.blue.opacity(0.8)
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
                        if isCodeFullScreen {
                            CodeView(code: message.text)
                                //                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width * 0.815,
                                       height: UIScreen.main.bounds.size.height * 0.8)
                                .onTapBackground(enabled: true) {
                                    withAnimation {
                                        isCodeFullScreen = false
                                    }
                                }

                            //                                .onTapGesture {
                            //                                    withAnimation {
                            //                                        isCodeFullScreen = false
                            //                                    }
                            //                                }
                        } else {
                            CodeView(code: message.text, thumbnailed: true)
                                .frame(width: UIScreen.main.bounds.size.width * 0.45,
                                       height: 200)
                                .onTapGesture {
                                    withAnimation {
                                        isCodeFullScreen = true
                                    }
                                }
                        }
                    } else {
                        Text(message.text)
                            .foregroundColor(.white)
                        content()
                    }

                    if message.role == .userRecordingInProcess || message.role == .userExpectingResponse {
                        ProgressView()
                            .tint(.yellow)
                            .frame(width: 10, height: 10)
                    }

                }.padding(10)

                    .background(BalloonShape(isFromCurrentUser: isFromCurrentUser)
                        .fill(backgroundColor))
                    .cornerRadius(4)
                    .padding(1)
                //                )

                if isFromCurrentUser {
                    Spacer()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.vertical, 1)
            .padding(.horizontal, 1)
            .opacity(isCodeFullScreen ? 1.0 : 0.4)
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
