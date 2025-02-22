//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by 이준우 on 2/22/25.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController.init()
    }
}
