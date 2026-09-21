import SwiftUI
import UIKit

struct PocketStateView: View {
    let duration: OutingDuration
    let startedAt: Date
    let onReturn: (Date) -> Void

    var body: some View {
        ZStack {
            Theme.pocketBlack.ignoresSafeArea()

            VStack {
                Text(duration.label)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.moss.opacity(0.5))
                    .padding(.top, 40)

                Spacer()

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                    onReturn(.now)
                } label: {
                    Text("I'm back")
                        .font(.system(size: 14))
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
    }
}

#Preview {
    PocketStateView(duration: .block, startedAt: .now, onReturn: { _ in })
}
