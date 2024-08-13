//
//  StatisticsView.swift
//  Pomo
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import Charts
import SwiftUI

struct StatisticsView: View {
    @ObservedObject var statisticsModel = StatisticsModel()

    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<24) { hour in
                        HStack {
                            Text("\(hour):00")
                                .frame(width: 60, alignment: .leading)
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: geometry.size.height / 24)
                        }
                    }

                    ForEach(statisticsModel.sessions) { session in
                        HStack {
                            Text(session.startTime, style: .time)
                                .frame(width: 60, alignment: .leading)
                            Rectangle()
                                .fill(session.isBreak ? Color.green : Color.red)
                                .frame(width: geometry.size.width - 60)
                                .frame(height: sessionHeight(session, in: geometry.size.height))
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }

    func sessionHeight(_ session: PomodoroSession, in totalHeight: CGFloat) -> CGFloat {
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: session.startTime)
        let startMinute = calendar.component(.minute, from: session.startTime)
        let endHour = calendar.component(.hour, from: session.endTime)
        let endMinute = calendar.component(.minute, from: session.endTime)

        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        let durationMinutes = endTotalMinutes - startTotalMinutes

        return CGFloat(durationMinutes) / (24 * 60) * totalHeight
    }
}


#Preview {
    StatisticsView()
}

#Preview {
    StatisticsView()
}
