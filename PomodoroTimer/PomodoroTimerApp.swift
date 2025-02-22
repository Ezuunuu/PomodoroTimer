//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by 이준우 on 2/22/25.
//

import SwiftUI

@main
struct PomodoroApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 600, minHeight: 500)
        }
    }
}
