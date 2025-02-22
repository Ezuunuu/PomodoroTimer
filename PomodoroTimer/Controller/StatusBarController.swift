//
//  StatusBarController.swift
//  PomodoroTimer
//
//  Created by 이준우 on 2/22/25.
//

import AppKit

class StatusBarController {
    private var statusItem: NSStatusItem
    private var startMenuItem: NSMenuItem!
    private var pauseMenuItem: NSMenuItem!
    private var quitMenuItem: NSMenuItem!

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        setupMenu()
        
        // ✅ NotificationCenter를 구독하여 메뉴 활성화
        NotificationCenter.default.addObserver(self, selector: #selector(enableMenuItems), name: Notification.Name("EnableMenuItems"), object: nil)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("EnableMenuItems"), object: nil)
        }
    }

    private func setupMenu() {
        let menu = NSMenu()
        
        startMenuItem = NSMenuItem(title: "Start Timer", action: #selector(startTimer), keyEquivalent: "S")
        startMenuItem.target = self
        startMenuItem.isEnabled = true // 등록 전 활성화를 해주어야 함

        pauseMenuItem = NSMenuItem(title: "Pause Timer", action: #selector(pauseTimer), keyEquivalent: "P")
        pauseMenuItem.target = self
        pauseMenuItem.isEnabled = true // 등록 전 활성화를 해주어야 함
        
        quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q")
        quitMenuItem.target = self
        quitMenuItem.isEnabled = true // 등록 전 활성화를 해주어야 함

        menu.addItem(startMenuItem)
        menu.addItem(pauseMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
        statusItem.button?.title = "🍅"
    }

    @objc private func startTimer() {
        NotificationCenter.default.post(name: Notification.Name("StartTimer"), object: nil)
    }

    @objc private func pauseTimer() {
        NotificationCenter.default.post(name: Notification.Name("PauseTimer"), object: nil)
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    @objc private func enableMenuItems() {
        DispatchQueue.main.async {
            self.startMenuItem.isEnabled = true
            self.pauseMenuItem.isEnabled = true
        }
    }
}

