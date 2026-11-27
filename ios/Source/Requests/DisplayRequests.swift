import Foundation

enum DashboardContentFormatter {
    static let statusHeader = "$TIME12$ $DATE$ $GBATT$"

    static func template(for content: String) -> String {
        content.isEmpty ? statusHeader : statusHeader + "\n\n" + content
    }
}

public struct DisplayTextRequest {
    public let text: String
    public let x: Int
    public let y: Int
    public let size: Int

    public init(text: String, x: Int = 0, y: Int = 0, size: Int = 24) {
        self.text = text
        self.x = x
        self.y = y
        self.size = size
    }

    var dictionary: [String: Any] {
        [
            "text": text,
            "x": x,
            "y": y,
            "size": size,
        ]
    }
}

struct DisplayEventRequest {
    let values: [String: Any]
}

public struct DashboardPositionRequest {
    public let height: Int
    public let depth: Int

    public init(height: Int, depth: Int) {
        self.height = height
        self.depth = depth
    }
}

// Ghost fork: public so apps can fill the G2 system menu. The G2 driver reads "name" (not "title")
// and "running", so both are sent; without "name" every item was dropped.
public struct DashboardMenuItem {
    public let title: String
    public let packageName: String
    public let values: [String: Any]

    public init(title: String, packageName: String, running: Bool = false, values: [String: Any] = [:]) {
        self.title = title
        self.packageName = packageName
        self.values = values.merging(["running": running]) { old, _ in old }
    }

    var dictionary: [String: Any] {
        values.merging(["title": title, "name": title, "packageName": packageName]) { _, new in new }
    }
}

/// Mirrors the TS `CalendarEvent` shape: { title, location?, time, endDate }
/// where `endDate` is unix seconds.
public struct CalendarEvent {
    public let title: String
    public let location: String?
    public let time: String
    public let endDate: Double

    public init(title: String, location: String? = nil, time: String, endDate: Double) {
        self.title = title
        self.location = location
        self.time = time
        self.endDate = endDate
    }

    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "time": time,
            "endDate": endDate,
        ]
        if let location {
            dict["location"] = location
        }
        return dict
    }
}
