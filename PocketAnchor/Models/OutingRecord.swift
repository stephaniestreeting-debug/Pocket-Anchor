import Foundation
import SwiftData

@Model
final class OutingRecord {
    var startDate: Date
    var actualDuration: TimeInterval
    var durationRawValue: String

    var duration: OutingDuration {
        OutingDuration(rawValue: durationRawValue) ?? .block
    }

    init(startDate: Date, actualDuration: TimeInterval, duration: OutingDuration) {
        self.startDate = startDate
        self.actualDuration = actualDuration
        self.durationRawValue = duration.rawValue
    }
}
