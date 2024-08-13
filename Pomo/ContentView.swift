//
//  ContentView.swift
//  Pomo
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    ContentView()
}
