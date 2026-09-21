import SwiftUI
import UIKit

struct PocketStateView: View {
    let duration: OutingDuration
    let startedAt: Date
    let onReturn: (Date) -> Void

    @State private var showReassurance = true

    var body: some View {
        ZStack {
            Theme.pocketBlack.ignoresSafeArea()

            VStack {
                Text(duration.label)
                    .font(.scalable(12))
                    .foregroundStyle(Theme.moss.opacity(0.5))
                    .padding(.top, 40)

                if showReassurance {
                    Text("Nothing's wrong. The screen just stays dark and quiet from here.")
                        .font(.scalable(13))
                        .foregroundStyle(Theme.moss.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 48)
                        .padding(.top, 24)
                        .transition(.opacity)
                }

                Spacer()

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                    onReturn(.now)
                } label: {
                    Text("I'm back")
                        .font(.scalable(14))
                        .foregroundStyle(Theme.moss)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Theme.moss.opacity(0.3), lineWidth: 0.5)
                        )
                }
                .padding(.bottom, 60)
            }
        }
        .statusBarHidden()
        .onAppear {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
            DepartureCue.play()
        }
        .task {
            try? await Task.sleep(for: .seconds(4))
            withAnimation(.easeOut(duration: 1.0)) {
                showReassurance = false
            }
        }
    }
}

#Preview {
    PocketStateView(duration: .block, startedAt: .now, onReturn: { _ in })
}
