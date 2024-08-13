//
//  SettingsView.swift
//  Pomo
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsModel = SettingsModel()

    var body: some View {
        Form {
            Section(header: Text("Sprint Duration")) {
                HStack {
                    Text("\(Int(settingsModel.sprintDuration / 60)) minutes")
                    Slider(value: $settingsModel.sprintDuration, in: 5...3600, step: 60)
                }
            }

            Section(header: Text("Break Duration")) {
                HStack {
                    Text("\(Int(settingsModel.breakDuration / 60)) minutes")
                    Slider(value: $settingsModel.breakDuration, in: 60...1800, step: 60)
                }
            }
        }
        .onDisappear {
            settingsModel.saveSettings()
        }
    }
}

#Preview {
    SettingsView()
}
