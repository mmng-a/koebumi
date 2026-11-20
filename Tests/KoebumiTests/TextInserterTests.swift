import AppKit
import Testing
@testable import Koebumi

@Suite @MainActor struct TextInserterTests {
    @Test(arguments: [KeyNames.vKey, KeyNames.cKey])
    func commandShortcutsReleaseSyntheticCommand(key: UInt16) throws {
        let events = TextInserter.keyEvents(key, flags: .maskCommand, releaseFlags: [])
        #expect(events.count == 2)
        let down = try #require(events.first)
        let up = try #require(events.last)
        #expect(down.type == .keyDown)
        #expect(up.type == .keyUp)
        #expect(down.flags == .maskCommand)
        #expect(up.flags.isEmpty)
        #expect(events.allSatisfy { $0.getIntegerValueField(.keyboardEventKeycode) == Int64(key) })
        #expect(events.allSatisfy { $0.getIntegerValueField(.eventSourceUserData) == syntheticEventMarker })
    }

    @Test(arguments: [CGEventFlags.maskShift, .maskCommand, .maskAlternate, .maskSecondaryFn])
    func keyReleaseRestoresPreviouslyHeldModifiers(flags: CGEventFlags) throws {
        let events = TextInserter.keyEvents(KeyNames.vKey, flags: .maskCommand, releaseFlags: flags)
        #expect(try #require(events.first).flags == .maskCommand)
        #expect(try #require(events.last).flags == flags)
    }
}
