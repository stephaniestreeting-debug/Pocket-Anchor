import Foundation
import SwiftData

@Model
final class OutingRecord {
    var startDate: Date
    var actualDuration: TimeInterval
    var durationRawValue: String
    var noticedCount: Int
    var mood: String?

    var duration: OutingDuration {
        OutingDuration(rawValue: durationRawValue) ?? .block
    }

    init(
        startDate: Date,
        actualDuration: TimeInterval,
        duration: OutingDuration,
        noticedCount: Int = 0,
        mood: String? = nil
    ) {
        self.startDate = startDate
        self.actualDuration = actualDuration
        self.durationRawValue = duration.rawValue
        self.noticedCount = noticedCount
        self.mood = mood
    }
}
