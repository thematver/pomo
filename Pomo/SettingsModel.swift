//
//  SettingsModel.swift
//  Pomo
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import Foundation

class SettingsModel: ObservableObject {
    @Published var sprintDuration: Double
    @Published var breakDuration: Double

    init() {
        let sprintDuration = UserDefaults.standard.double(forKey: "sprintDuration")
        self.sprintDuration = sprintDuration == 0 ? 1500 : sprintDuration

        let breakDuration = UserDefaults.standard.double(forKey: "breakDuration")
        self.breakDuration = breakDuration == 0 ? 300 : breakDuration
    }

    func saveSettings() {
        UserDefaults.standard.set(sprintDuration, forKey: "sprintDuration")
        UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
    }
}
