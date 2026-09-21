import SwiftUI
import SwiftData

struct ReturnSummaryView: View {
    let record: OutingRecord
    let onDone: () -> Void

    @Environment(\.modelContext) private var modelContext

    @State private var noticedCount: Int = 0
    @State private var selectedMood: String?

    private let moodOptions = ["Lighter", "About the same", "Heavier"]
    private let maxDots = 6

    private var minutes: Int {
        max(1, Int((record.actualDuration / 60).rounded()))
    }

    private var recapLine: String? {
        var parts: [String] = []
        if noticedCount > 0 {
            parts.append("You noticed \(noticedCount) thing\(noticedCount == 1 ? "" : "s").")
        }
        if let selectedMood {
            parts.append("Feeling \(selectedMood.lowercased()).")
        }
        return parts.isEmpty ? nil : parts.joined(separator: " ")
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

                    if let recapLine {
                        Text(recapLine)
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.softInk)
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
