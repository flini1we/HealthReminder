import UIKit

protocol IDateFormatter {
    
    func format(_ date: Date, style: DateFormatter.Style) -> String
    func timeAgo(from date: Date) -> String
    func formatRelative(_ date: Date) -> String
}

final class DateFormatter: IDateFormatter {
    
    static let standard: IDateFormatter = DateFormatter()
    
    private init() { }
    
    enum Style {
        case short
        case medium
        case long
        case relative
        case smart
    }
    
    private lazy var dateFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.locale = .current
        return formatter
    }()
    
    private lazy var relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = .current
        formatter.unitsStyle = .full
        return formatter
    }()
    
    func format(_ date: Date, style: Style) -> String {
        switch style {
        case .short:
            return formatShort(date)
        case .medium:
            return formatMedium(date)
        case .long:
            return formatLong(date)
        case .relative:
            return timeAgo(from: date)
        case .smart:
            return formatSmart(date)
        }
    }
    
    func timeAgo(from date: Date) -> String {
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    func formatRelative(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today, \(formatShort(date))"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow, \(formatShort(date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday, \(formatShort(date))"
        } else {
            return formatLong(date)
        }
    }
    
    private func formatShort(_ date: Date) -> String {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    private func formatMedium(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today, \(formatShort(date))"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow, \(formatShort(date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday, \(formatShort(date))"
        } else {
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    
    private func formatLong(_ date: Date) -> String {
        dateFormatter.dateFormat = "EEEE, MMMM d 'at' h:mm a"
        return dateFormatter.string(from: date)
    }
    
    private func formatSmart(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // If date is within next 24 hours
        if let hours = calendar.dateComponents([.hour], from: now, to: date).hour,
           hours >= 0 && hours < 24 {
            return timeAgo(from: date)
        }
        
        // If date is within this week
        if let days = calendar.dateComponents([.day], from: now, to: date).day,
           days >= -7 && days <= 7 {
            return formatRelative(date)
        }
        
        // If date is within this year
        if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            dateFormatter.dateFormat = "MMM d 'at' h:mm a"
            return dateFormatter.string(from: date)
        }
        
        // Default to long format for dates far in the past or future
        return formatLong(date)
    }
}
