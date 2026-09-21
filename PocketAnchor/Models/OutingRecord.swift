import Foundation
import SwiftData

@Model
final class OutingRecord {
    var startDate: Date
    var actualDuration: TimeInterval
    var intendedLabel: String
    var noticedCount: Int
    var mood: String?

    init(
        startDate: Date,
        actualDuration: TimeInterval,
        intendedLabel: String,
        noticedCount: Int = 0,
        mood: String? = nil
    ) {
        self.startDate = startDate
        self.actualDuration = actualDuration
        self.intendedLabel = intendedLabel
        self.noticedCount = noticedCount
        self.mood = mood
    }
}
