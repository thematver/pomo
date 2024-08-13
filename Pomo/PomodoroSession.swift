//
//  PomodoroSession.swift
//  Pomo
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import Foundation

struct PomodoroSession: Identifiable {
    let id = UUID()
    let date: Date
    let startTime: Date
    let endTime: Date
    let isBreak: Bool
}

import Foundation

class StatisticsModel: ObservableObject {
    @Published var sessions: [PomodoroSession] = [
        // Example data
        PomodoroSession(date: Date(), startTime: Calendar.current.date(bySettingHour: 0, minute: 30, second: 0, of: Date())!, endTime: Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!, isBreak: false),
        PomodoroSession(date: Date(), startTime: Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(bySettingHour: 2, minute: 0, second: 0, of: Date())!, isBreak: true),
    ]
}
