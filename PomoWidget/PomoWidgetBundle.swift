//
//  PomoWidgetBundle.swift
//  PomoWidget
//
//  Created by Матвей Корепанов on 04.07.2024.
//

import WidgetKit
import SwiftUI

@main
struct PomoWidgetBundle: WidgetBundle {
    var body: some Widget {
        PomoWidget()
        PomodoroWidgetLiveActivity()
    }
}
