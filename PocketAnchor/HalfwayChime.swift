import AVFoundation
import UserNotifications

/// Renders and caches a single soft notification sound file. Local
/// notification sounds must be real files on disk (unlike the live
/// AVAudioEngine synthesis used for the departure chime) - this reuses the
/// same synthesis approach, just written to disk once instead of played
/// live, and kept deliberately shorter/lighter than the departure cadence
/// so it doesn't feel like a repeat of it.
enum HalfwayChimeSound {
    static let fileName = "halfway_chime.caf"

    static func ensureCached() {
        let url = soundsDirectoryURL().appendingPathComponent(fileName)
        guard !FileManager.default.fileExists(atPath: url.path) else { return }
        render(to: url)
    }

    private static func soundsDirectoryURL() -> URL {
        let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let sounds = library.appendingPathComponent("Sounds")
        try? FileManager.default.createDirectory(at: sounds, withIntermediateDirectories: true)
        return sounds
    }

    private static func render(to url: URL) {
        let sampleRate = 44_100.0
        let duration = 0.9
        let frequency = 493.88
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?[0] else { return }
        buffer.frameLength = frameCount

        let attackFrames = Int(0.01 * sampleRate)
        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate
            let attack = i < attackFrames ? Double(i) / Double(attackFrames) : 1.0
            let decay = exp(-t * 2.6)
            let envelope = attack * decay
            let fundamental = sin(2.0 * Double.pi * frequency * t)
            let overtone = sin(2.0 * Double.pi * frequency * 2.01 * t) * 0.16
            channel[i] = Float((fundamental + overtone) * envelope * 0.22)
        }

        guard let audioFile = try? AVAudioFile(forWriting: url, settings: format.settings) else { return }
        try? audioFile.write(from: buffer)
    }
}

/// Schedules (and cancels) the halfway-point local notification. A local
/// notification is used rather than an in-app timer because the phone is
/// expected to be locked or the app backgrounded during the walk - an
/// in-app timer would simply not fire in that state.
enum HalfwayChimeScheduler {
    private static let identifier = "pocketAnchor.halfwayChime"

    /// `completion` always runs on the main thread, whether or not
    /// permission was granted - callers use it to gate a screen transition
    /// so the permission dialog (only ever shown once, the first time)
    /// fully resolves before the screen goes dark, rather than the dialog
    /// appearing to interrupt an already-darkening screen.
    static func schedule(for duration: OutingDuration, completion: @escaping () -> Void = {}) {
        guard let seconds = duration.approximateSeconds else {
            DispatchQueue.main.async(execute: completion)
            return
        }
        let halfway = max(1, seconds / 2)

        HalfwayChimeSound.ensureCached()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            defer { DispatchQueue.main.async(execute: completion) }
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "Pocket Anchor"
            content.body = "You're halfway. Head back if you want to, or don't."
            content.sound = UNNotificationSound(named: UNNotificationSoundName(HalfwayChimeSound.fileName))

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: halfway, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

    static func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
