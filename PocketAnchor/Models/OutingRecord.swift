import Foundation
import SwiftData

@Model
final class OutingRecord {
    var startDate: Date
    var actualDuration: TimeInterval
    var intendedLabel: String
    var noticedPrompts: [String]

    init(startDate: Date, actualDuration: TimeInterval, intendedLabel: String, noticedPrompts: [String] = []) {
        self.startDate = startDate
        self.actualDuration = actualDuration
        self.intendedLabel = intendedLabel
        self.noticedPrompts = noticedPrompts
    }
}
