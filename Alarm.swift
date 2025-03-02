import Foundation

class Alarm: Identifiable, Codable {
    let id: String
    var time: Date
    var isEnabled: Bool
    var label: String
    var daysOfWeek: Set<Int>  // 1 = 日曜, 2 = 月曜, etc.
    var soundName: String
    var snoozeEnabled: Bool
    var snoozeInterval: Int  // 分単位
    
    init(
        id: String = UUID().uuidString,
        time: Date = Date(),
        isEnabled: Bool = true,
        label: String = "",
        daysOfWeek: Set<Int> = [],
        soundName: String = "default",
        snoozeEnabled: Bool = true,
        snoozeInterval: Int = 9
    ) {
        self.id = id
        self.time = time
        self.isEnabled = isEnabled
        self.label = label
        self.daysOfWeek = daysOfWeek
        self.soundName = soundName
        self.snoozeEnabled = snoozeEnabled
        self.snoozeInterval = snoozeInterval
    }
} 