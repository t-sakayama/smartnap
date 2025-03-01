class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadAlarms()
    }
    
    // アラームの保存と読み込み
    private func loadAlarms() {
        if let data = userDefaults.data(forKey: "savedAlarms"),
           let decodedAlarms = try? JSONDecoder().decode([Alarm].self, from: data) {
            self.alarms = decodedAlarms
        }
    }
    
    private func saveAlarms() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            userDefaults.set(encoded, forKey: "savedAlarms")
        }
    }
    
    // CRUD操作
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
        saveAlarms()
        scheduleNotification(for: alarm)
    }
    
    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            saveAlarms()
            scheduleNotification(for: alarm)
        }
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
        cancelNotification(for: alarm)
    }
    
    func toggleAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isEnabled.toggle()
            saveAlarms()
            if alarms[index].isEnabled {
                scheduleNotification(for: alarms[index])
            } else {
                cancelNotification(for: alarms[index])
            }
        }
    }
} 