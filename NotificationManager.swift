import Foundation
import UserNotifications
import AVFoundation

class NotificationManager {
    static let shared = NotificationManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        requestAuthorization()
        setupAudioSession()
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知の許可を得ました")
            }
        }
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession設定エラー: \(error)")
        }
    }
    
    func scheduleNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "アラーム"
        content.body = alarm.label.isEmpty ? "起床時間です" : alarm.label
        content.sound = UNNotificationSound.default
        
        // 次の通知時間を計算
        let components = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: !alarm.daysOfWeek.isEmpty)
        
        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id])
    }
    
    func playAlarmSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // 無限ループ
            audioPlayer?.play()
        } catch {
            print("音声再生エラー: \(error)")
        }
    }
    
    func stopAlarmSound() {
        audioPlayer?.stop()
    }
} 