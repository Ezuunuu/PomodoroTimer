//
//  PomodoroViewModel.swift.swift
//  PomodoroTimer
//
//  Created by 이준우 on 2/22/25.
//

import SwiftUI
import RxSwift
import RxCocoa
import AppKit

class PomodoroViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private var timer: Observable<Int>?
    
    @Published var timeRemaining = 1500 // Default 25 minutes
    @Published var isRunning = false
    @Published var pauseTimes: [(String, Int)] = []
    @Published var workDuration: Int = UserDefaults.standard.integer(forKey: "workDuration") == 0 ? 1500 : UserDefaults.standard.integer(forKey: "workDuration")
    @Published var restDuration: Int = UserDefaults.standard.integer(forKey: "restDuration") == 0 ? 300 : UserDefaults.standard.integer(forKey: "restDuration")
    
    private let timerSubject = PublishSubject<Void>()
    private let stopSubject = PublishSubject<Void>()
    
    init() {
        loadPauseHistory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleStartTimer), name: Notification.Name("StartTimer"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(handlePauseTimer), name: Notification.Name("PauseTimer"), object: nil)
        
        timer = timerSubject
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .take(until: self.stopSubject)
            }
            .share()
        
        timer?.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.isRunning = false
                self.switchToRestPeriod()
            }
        }).disposed(by: disposeBag)
    }
    
    func toggleTimer() {
        DispatchQueue.main.async {
            if self.isRunning {
                self.stopSubject.onNext(())
                self.isRunning = false
                self.addPauseTime()
            } else {
                self.isRunning = true
                self.timerSubject.onNext(())
            }
        }
    }
    
    func resetTimer() {
        DispatchQueue.main.async {
            self.stopSubject.onNext(())
            self.isRunning = false
            self.timeRemaining = self.workDuration
            self.pauseTimes.removeAll()
            self.savePauseHistory()
        }
    }
    
    private func addPauseTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let timeString = formatter.string(from: Date())
        pauseTimes.append(("Paused at: " + timeString, timeRemaining))
        savePauseHistory()
    }
    
    private func savePauseHistory() {
        UserDefaults.standard.set(pauseTimes.map { "\($0.0)|\($0.1)" }, forKey: "pauseHistory")
    }
    
    private func loadPauseHistory() {
        if let savedData = UserDefaults.standard.array(forKey: "pauseHistory") as? [String] {
            pauseTimes = savedData.compactMap {
                let components = $0.split(separator: "|")
                guard components.count == 2, let time = Int(components[1]) else { return nil }
                return (String(components[0]), time)
            }
        }
    }
    
    private func switchToRestPeriod() {
        timeRemaining = restDuration
        isRunning = true
        timerSubject.onNext(())
    }
    
    func removePauseTime(at index: Int) {
        pauseTimes.remove(at: index)
        savePauseHistory()
    }

    @objc private func handleStartTimer() {
        DispatchQueue.main.async {
            self.toggleTimer()
        }
    }
    
    @objc private func handlePauseTimer() {
        DispatchQueue.main.async {
            self.toggleTimer()
        }
    }
}

