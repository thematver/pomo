//
//  PomoWidgetLiveActivity.swift
//  PomoWidget
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: Int
        var isBreak: Bool
    }

    var name: String
}

struct PomodoroWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            LiveActivityView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("⏱️")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timeString(time: context.state.timeRemaining))
                        .font(.headline)
                        .foregroundColor(.red)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text("Time Remaining")
                            .font(.caption)
                        Text(timeString(time: context.state.timeRemaining))
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            } compactLeading: {
                Text("⏱️")
            } compactTrailing: {
                Text(timeString(time: context.state.timeRemaining))
                    .font(.caption2)
                    .foregroundColor(.red)
            } minimal: {
                Text(timeString(time: context.state.timeRemaining))
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

struct LiveActivityView: View {
    let state: PomodoroAttributes.ContentState

    var body: some View {
        HStack(alignment: .center) {
            Text("Ваш Помо")
                .font(.headline)
                .foregroundColor(state.isBreak ? .green : .red)
                .bold()
            Spacer()
            Text(timeString(time: state.timeRemaining))
                .font(.largeTitle)
                .foregroundColor(state.isBreak ? .green : .red)
        }
        .padding()
    }
}

func timeString(time: Int) -> String {
    let minutes = time / 60
    let seconds = time % 60
    return String(format: "%02d:%02d", minutes, seconds)
}
