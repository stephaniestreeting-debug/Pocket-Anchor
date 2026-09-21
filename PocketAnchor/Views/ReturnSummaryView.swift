import SwiftUI
import SwiftData

struct ReturnSummaryView: View {
    let record: OutingRecord
    let onDone: () -> Void

    @Environment(\.modelContext) private var modelContext

    @State private var noticedCount: Int = 0
    @State private var selectedMood: String?
    @State private var encouragementNote: String = EncouragementBank.randomNote()

    private let moodOptions = ["Lighter", "About the same", "Heavier"]
    private let maxDots = 6

    private var minutes: Int {
        max(1, Int((record.actualDuration / 60).rounded()))
    }

    private var recapLine: String? {
        let countPart: String?
        switch noticedCount {
        case 0: countPart = nil
        case 1: countPart = "One small thing caught your eye"
        case 2...3: countPart = "A few things caught your eye"
        case 4...5: countPart = "Quite a few things caught your eye"
        default: countPart = "Plenty caught your eye today"
        }

        let moodLower: String?
        let moodStandalone: String?
        switch selectedMood {
        case "Lighter":
            moodLower = "you're leaving lighter than you arrived"
            moodStandalone = "You're leaving lighter than you arrived."
        case "About the same":
            moodLower = "you're leaving about how you arrived, steady"
            moodStandalone = "You're leaving about how you arrived, steady."
        case "Heavier":
            moodLower = "today was heavier, and that's alright"
            moodStandalone = "Today was heavier, and that's alright."
        default:
            moodLower = nil
            moodStandalone = nil
        }

        if let countPart, let moodLower {
            return "\(countPart), and \(moodLower)."
        } else if let countPart {
            return "\(countPart)."
        } else if let moodStandalone {
            return moodStandalone
        }
        return nil
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome back.")
                            .font(.system(size: 26, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.charcoal)

                        Text("You spent \(minutes) minute\(minutes == 1 ? "" : "s") outside. Your phone stayed in your pocket where it belonged.")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Did anything catch your eye?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.charcoal)
                        Text("Tap for each thing you remember, however small.")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.softInk)

                        HStack(spacing: 14) {
                            ForEach(0..<maxDots, id: \.self) { index in
                                Circle()
                                    .fill(index < noticedCount ? Theme.clay : Color.clear)
                                    .overlay(Circle().stroke(Theme.clay.opacity(0.5), lineWidth: 1))
                                    .frame(width: 26, height: 26)
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        noticedCount = (index < noticedCount) ? index : index + 1
                                        save()
                                    }
                                    .accessibilityLabel("Notice")
                            }
                        }
                        .padding(.top, 4)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How do you feel?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.charcoal)

                        HStack(spacing: 8) {
                            ForEach(moodOptions, id: \.self) { option in
                                Button {
                                    selectedMood = (selectedMood == option) ? nil : option
                                    save()
                                } label: {
                                    Text(option)
                                        .font(.system(size: 12))
                                        .foregroundStyle(selectedMood == option ? Theme.paper : Theme.charcoal)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedMood == option ? Theme.forest : Theme.moss.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        if let recapLine {
                            Text(recapLine)
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.softInk)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text(encouragementNote)
                            .font(.system(size: 12))
                            .italic()
                            .foregroundStyle(Theme.softInk.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: 8) {
                        Button {
                            onDone()
                        } label: {
                            Text("That's it")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Theme.paper)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.forest)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        Text("Nothing to finish, nothing to log.")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.softInk)
                    }
                    .padding(.top, 12)
                }
                .padding(24)
            }
        }
        .onAppear {
            modelContext.insert(record)
            try? modelContext.save()
        }
    }

    private func save() {
        record.noticedCount = noticedCount
        record.mood = selectedMood
        try? modelContext.save()
    }
}

#Preview {
    ReturnSummaryView(
        record: OutingRecord(startDate: .now, actualDuration: 620, intendedLabel: "10 min"),
        onDone: {}
    )
    .modelContainer(for: OutingRecord.self, inMemory: true)
}
