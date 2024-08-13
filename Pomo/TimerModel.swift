import ActivityKit
import AVFoundation
import Foundation
import UserNotifications

struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: Int
        var isBreak: Bool
    }

    var name: String
}

class TimerModel: ObservableObject {
    @Published var isRunning = false
    @Published var isBreak = false
    @Published var timeRemaining: Int
    var sprintDuration: Int
    var breakDuration: Int
    var player: AVAudioPlayer?
    var timer: Timer?
    var activity: Activity<PomodoroAttributes>?

    func updateValues() {
        let sprintDuration = Int(UserDefaults.standard.double(forKey: "sprintDuration"))
        self.sprintDuration = sprintDuration == 0 ? 1500 : sprintDuration

        let breakDuration = Int(UserDefaults.standard.double(forKey: "breakDuration"))
        self.breakDuration = breakDuration == 0 ? 300 : breakDuration

        timeRemaining = isBreak ? self.breakDuration : self.sprintDuration
    }

    init() {
        let sprintDuration = Int(UserDefaults.standard.double(forKey: "sprintDuration"))
        self.sprintDuration = sprintDuration == 0 ? 1500 : sprintDuration

        let breakDuration = Int(UserDefaults.standard.double(forKey: "breakDuration"))
        self.breakDuration = breakDuration == 0 ? 300 : breakDuration

        self.timeRemaining = self.sprintDuration
        
    }

    func startTimer() {

        if isRunning {
            timer?.invalidate()
        } else {
            updateValues()
            startWork()
        }
        isRunning.toggle()
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "wav") else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = player else {
                return
            }

            player.play()

        } catch {
            print(error.localizedDescription)
        }
    }

    func startWork() {
        self.sendNotification(title: "Go work", body: "Time to work!")
        playSound()
        isBreak = false
        timeRemaining = sprintDuration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateLiveActivity()
            } else {
                self.timer?.invalidate()
                self.sendNotification(title: "Work Finished", body: "Time to break!")
                self.startBreak()
            }
        }
    }

    func startBreak() {
        playSound()
        isBreak = true
        timeRemaining = breakDuration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateLiveActivity()
            } else {
                self.timer?.invalidate()
                self.sendNotification(title: "Break Finished", body: "Time to work!")
                self.startWork()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        isRunning = false
        timeRemaining = sprintDuration
        endLiveActivity()
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled: \(title) - \(body)")
            }
        }
    }

    func startLiveActivity() {
        let attributes = PomodoroAttributes(name: "Pomodoro Timer")
        let state = PomodoroAttributes.ContentState(timeRemaining: timeRemaining, isBreak: isBreak)
        let content = ActivityContent(state: state, staleDate: nil, relevanceScore: 1.0)

        do {
            activity = try Activity<PomodoroAttributes>.request(attributes: attributes, content: content, pushType: nil)
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }
    }

    func updateLiveActivity() {
        let state = PomodoroAttributes.ContentState(timeRemaining: timeRemaining, isBreak: isBreak)

        Task {
            await activity?.update(using: state)
        }
    }

    func endLiveActivity() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
        }
    }
}
