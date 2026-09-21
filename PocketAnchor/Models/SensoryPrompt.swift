import Foundation

enum SensoryPromptBank {
    static let seeds: [String] = [
        "Maybe there's a texture worth touching today — bark, stone, a cold railing.",
        "There's a particular smell in the air right before rain.",
        "There might be a color out there brighter than you expect.",
        "Clouds are good at looking like other things, if you watch for a moment.",
        "There are sounds you only hear outdoors — worth a listen.",
        "The air might feel different on your skin today, in a good way.",
        "A bird, a leaf, a squirrel — something small might be moving nearby, worth noticing.",
        "A small plant might be growing somewhere unexpected, like a crack in the pavement.",
        "Late-day light can do lovely things to walls, windows, and puddles.",
        "Somewhere nearby, someone's dog is having a really good day."
    ]

    static func randomSeed() -> String {
        seeds.randomElement() ?? seeds[0]
    }
}
