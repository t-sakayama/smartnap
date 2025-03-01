import Foundation

extension Date {
    func nextDate(weekday: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(hour: calendar.component(.hour, from: self),
                                     minute: calendar.component(.minute, from: self))
        
        var date = calendar.date(from: components) ?? self
        
        while calendar.component(.weekday, from: date) != weekday {
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        if date < Date() {
            date = calendar.date(byAdding: .day, value: 7, to: date) ?? date
        }
        
        return date
    }
} 