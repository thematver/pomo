import SwiftUI
import ActivityKit
import UserNotifications
struct TimerView: View {
    @ObservedObject var timerModel = TimerModel()

    var body: some View {
        VStack {
            Spacer()
            Text(timeString(time: timerModel.timeRemaining))
                .font(.largeTitle)
                .foregroundColor(timerModel.isBreak ? .green : .pink)
                .padding(.top, 50)

            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(timerModel.isBreak ? .green.opacity(0.1) : .pink.opacity(0.1))

                Circle()
                    .trim(from: 0.0, to: 1.0 - CGFloat(Double(timerModel.timeRemaining) / Double(timerModel.isBreak ? timerModel.breakDuration : timerModel.sprintDuration)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(timerModel.isBreak ? .green : .red)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: timerModel.timeRemaining)

                Text(timerModel.isBreak ? "🚬" : "🍅")
                    .font(.system(size: 100))
                    .onTapGesture {
                        timerModel.startTimer()
                    }
                    .onLongPressGesture {
                        timerModel.stopTimer()
                    }
            }
            .padding(40)

            Spacer()
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
                // Handle the granted/error
            }
            timerModel.updateValues()
        }
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TimerView(timerModel: TimerModel())
}
