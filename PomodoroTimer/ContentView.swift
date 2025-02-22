//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by 이준우 on 2/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PomodoroViewModel()
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 20)
                
                Text("Pomodoro Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                VStack(spacing: 10) {
                    Text("Work Duration")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Picker("Work Duration", selection: $viewModel.workDuration) {
                        Text("25 min").tag(1500)
                        Text("50 min").tag(3000)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                .padding()
                
                VStack(spacing: 10) {
                    Text("Rest Duration")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Picker("Rest Duration", selection: $viewModel.restDuration) {
                        Text("5 min").tag(300)
                        Text("10 min").tag(600)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
                .padding()
                
                Button(action: {
                    UserDefaults.standard.set(viewModel.workDuration, forKey: "workDuration")
                    UserDefaults.standard.set(viewModel.restDuration, forKey: "restDuration")
                }) {
                    Text("Save Settings")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                Slider(value: $opacity, in: 0.3...1.0, step: 0.1)
                    .padding(.horizontal)
                    .accentColor(.blue)
                    .onChange(of: opacity) { newValue in
                        if let window = NSApplication.shared.windows.first {
                            window.alphaValue = newValue
                        }
                    }
                Text("\(viewModel.timeRemaining / 60):\(String(format: "%02d", viewModel.timeRemaining % 60))")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue.opacity(0.2)))
                    .frame(width: 200)
                
                HStack(spacing: 20) {
                    Button(action: { viewModel.toggleTimer() }) {
                        Text(viewModel.isRunning ? "Pause" : "Start")
                            .font(.headline)
                            .padding()
                            .frame(width: 120)
                    }
                    
                    Button(action: { viewModel.resetTimer() }) {
                        Text("Reset")
                            .font(.headline)
                            .padding()
                            .frame(width: 120)
                    }
                }
                
                List {
                    ForEach(viewModel.pauseTimes.indices, id: \ .self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewModel.pauseTimes[index].0)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Remaining: \(viewModel.pauseTimes[index].1 / 60):\(String(format: "%02d", viewModel.pauseTimes[index].1 % 60))")
                                    .font(.headline)
                            }
                            Spacer()
                            Button(action: { viewModel.removePauseTime(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                        .padding(5)
                    }
                }
                .frame(height: 200)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                .padding()
            }
            .padding()
        }
    }
}
