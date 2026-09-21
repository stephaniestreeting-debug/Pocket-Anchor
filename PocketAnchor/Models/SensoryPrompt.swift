import Foundation

enum SensoryPromptBank {
    static let seeds: [String] = [
        "Maybe there's a texture worth touching today.",
        "Rain always smells like something before it arrives.",
        "There might be a color out there you didn't expect.",
        "Clouds are usually pretending to be something else.",
        "Some sounds only exist outside.",
        "The air might feel different on your skin today.",
        "Something out there is probably moving on its own.",
        "Plants have a way of showing up where they shouldn't.",
        "Light does strange things to surfaces in the late day.",
        "Somewhere out there, someone else's dog is having a very important day."
    ]

    static func randomSeed() -> String {
        seeds.randomElement() ?? seeds[0]
    }
}
