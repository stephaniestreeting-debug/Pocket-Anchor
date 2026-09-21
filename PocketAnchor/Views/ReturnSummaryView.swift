import SwiftUI
import SwiftData

struct ReturnSummaryView: View {
    let record: OutingRecord
    let onDone: () -> Void

    @Environment(\.modelContext) private var modelContext

    private var minutes: Int {
        max(1, Int((record.actualDuration / 60).rounded()))
    }

    private var welcomeLine: String {
        let minuteWord = "minute\(minutes == 1 ? "" : "s")"
        switch record.duration {
        case .doorway:
            return "You spent \(minutes) \(minuteWord) at the door. That's the whole thing today. Your phone stayed in your pocket where it belonged."
        case .nearby:
            return "You spent \(minutes) \(minuteWord) close to home. Your phone stayed in your pocket where it belonged."
        case .block, .wander, .open:
            return "You spent \(minutes) \(minuteWord) outside — however long that was, it's enough. Your phone stayed in your pocket where it belonged."
        }
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome back.")
                            .font(.scalable(26, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.charcoal)

                        Text(welcomeLine)
                            .font(.scalable(15))
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Whatever that looked like today, it counts.")
                            .font(.scalable(15))
                            .italic()
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 4)
                    }
                    .padding(.top, 20)

                    VStack(spacing: 6) {
                        Button {
                            onDone()
                        } label: {
                            Text("That's it")
                                .font(.scalable(16, weight: .medium))
                                .foregroundStyle(Theme.cream)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.forest)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        Text("Nothing to finish, nothing to log.")
                            .font(.scalable(12))
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
}

#Preview {
    ReturnSummaryView(
        record: OutingRecord(startDate: .now, actualDuration: 620, duration: .block),
        onDone: {}
    )
    .modelContainer(for: OutingRecord.self, inMemory: true)
}
