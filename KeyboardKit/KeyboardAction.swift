enum KeyboardAction {
    /// An action to cancelling an in-progress task or dismiss a prompt, consisting of the Escape (⎋) key and no modifiers.
    case cancel

    /// A close action, consisting of the 'W' key and the Command (⌘) modifier.
    case close

    /// A done action, consisting of the Return (↩) key and the Command (⌘) modifier.
    case done

    /// A save action, consisting of the 'S' key and the Command (⌘) modifier.
    case save

    /// A save action, consisting of the 'I' key and the Command (⌘) modifier.
    case share

    /// An edit action, consisting of the 'E' key and the Command (⌘) modifier.
    case edit

    /// A creation action, consisting of the 'N' key and the Command (⌘) modifier.
    case new

    /// A reply action, consisting of the 'R' key and the Command (⌘) modifier.
    case reply

    /// A refresh action, consisting of the 'R' key and the Command (⌘) modifier.
    case refresh

    /// An action for viewing bookmarks, consisting of the 'B' key and the Command (⌘) modifier.
    case bookmarks

    /// A search action, consisting of the 'F' key and the Command (⌘) modifier.
    case search

    /// A deletion action, consisting of the Delete (⌫) key and the Command (⌘) modifier.
    case delete

    /// An action for viewing content relating to the current day, consisting of the 'T' key and the Command (⌘) modifier.
    case today

    /// A zoom-in action, consisting of the equals (=) key and the Command (⌘) modifier.
    case zoomIn

    /// A zoom-out action, consisting of the minus (-) key and the Command (⌘) modifier.
    case zoomOut

    /// An action to zoom content to its actual size, consisting of the 0 key and the Command (⌘) modifier.
    case zoomToActualSize

    /// A rewind action, consisting of the left arrow (←) key and the Command (⌘) modifier.
    case rewind

    /// A fast-forward action, consisting of the right arrow (→) key and the Command (⌘) modifier.
    case fastForward
}

// MARK: - Key Equivalent

extension KeyboardAction {
    var keyEquivalent: (modifierFlags: UIKeyModifierFlags, input: String) {
        switch self {
        case .cancel:           return ([], .escape)
        case .close:            return (.command, "w")
        // Apparently "\u{3}" might work for enter (not return) but not quite. Shows up in the HUD with no key and I couldn’t get it to trigger. For now use cmd + return instead.
        // Sources: https://forums.developer.apple.com/thread/119584 and https://stackoverflow.com/questions/56963348/uikeycommand-for-the-enter-key-on-mac-keyboards-numeric-keypad.
        case .done:             return (.command, .returnOrEnter)
        case .save:             return (.command, "s")
        case .share:            return (.command, "i") // Safari uses this for Email This Page. Also indirectly recommended in https://developer.apple.com/wwdc20/10117.
        case .edit:             return (.command, "e")
        case .new:              return (.command, "n")
        case .reply:            return (.command, "r")
        case .refresh:          return (.command, "r")
        case .bookmarks:        return (.command, "b") // opt + cmd + B or shift + cmd + B might be better to be more like Safari.
        case .search:           return (.command, "f")
        case .delete:           return (.command, .delete)
        case .today:            return (.command, "t")
        case .zoomIn:           return (.command, "=")
        case .zoomOut:          return (.command, "-")
        case .zoomToActualSize: return (.command, "0")
        case .rewind:           return (.command, .leftArrow)
        case .fastForward:      return (.command, .rightArrow)
        }
    }
}

// MARK: - KeyboardShortcut

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, *)
extension KeyboardAction {
    var keyboardShortcut: KeyboardShortcut {
        let equivalent = keyEquivalent
        let keyEquivalent = KeyEquivalent(Character(equivalent.input))
        let modifiers = equivalent.modifierFlags.eventModifiers

        switch self {
        case .cancel:
            return .cancelAction
        case .rewind, .fastForward:
            if #available(iOS 15.0, *) {
                return .init(keyEquivalent, modifiers: modifiers, localization: .withoutMirroring)
            }

            fallthrough
        default:
            return .init(keyEquivalent, modifiers: modifiers)
        }
    }
}

@available(iOS 14.0, *)
extension KeyboardShortcut {
    /// The namespace for keyboard shortcuts defined by KeyboardKit.
    public enum KeyboardKit {}
}

@available(iOS 14.0, *)
extension KeyboardShortcut.KeyboardKit {
    /// A keyboard shortcut for a close action, consisting of the 'W' key and the Command (⌘) modifier.
    public static let close = KeyboardAction.close.keyboardShortcut

    /// A keyboard shortcut for a done action, consisting of the Return (↩) key and the Command (⌘) modifier.
    public static let done = KeyboardAction.done.keyboardShortcut

    /// A keyboard shortcut for a save action, consisting of the 'S' key and the Command (⌘) modifier.
    public static let save = KeyboardAction.save.keyboardShortcut

    /// A keyboard shortcut for showing the share sheet, consisting of the 'I' key and the Command (⌘) modifier.
    public static let share = KeyboardAction.share.keyboardShortcut

    /// A keyboard shortcut for an edit action, consisting of the 'E' key and the Command (⌘) modifier.
    public static let edit = KeyboardAction.edit.keyboardShortcut

    /// A keyboard shortcut for a creation action, consisting of the 'N' key and the Command (⌘) modifier.
    public static let new = KeyboardAction.new.keyboardShortcut

    /// A keyboard shortcut for a reply action, consisting of the 'R' key and the Command (⌘) modifier.
    public static let reply = KeyboardAction.reply.keyboardShortcut

    /// A keyboard shortcut for a refresh action, consisting of the 'R' key and the Command (⌘) modifier.
    public static let refresh = KeyboardAction.refresh.keyboardShortcut

    /// A keyboard shortcut for an action for viewing bookmarks, consisting of the 'B' key and the Command (⌘) modifier.
    public static let bookmarks = KeyboardAction.bookmarks.keyboardShortcut

    /// A keyboard shortcut for a search action, consisting of the 'F' key and the Command (⌘) modifier.
    public static let search = KeyboardAction.search.keyboardShortcut

    /// A keyboard shortcut for a deletion action, consisting of the Delete (⌫) key and the Command (⌘) modifier.
    public static let delete = KeyboardAction.delete.keyboardShortcut

    /// A keyboard shortcut for an action for viewing content relating to the current day, consisting of the 'T' key and the Command (⌘) modifier.
    public static let today = KeyboardAction.today.keyboardShortcut

    /// A keyboard shortcut for a zoom-in action, consisting of the equals (=) key and the Command (⌘) modifier.
    public static let zoomIn = KeyboardAction.zoomIn.keyboardShortcut

    /// A keyboard shortcut for a zoom-out action, consisting of the minus (-) key and the Command (⌘) modifier.
    public static let zoomOut = KeyboardAction.zoomOut.keyboardShortcut

    /// A keyboard shortcut for an action to zoom content to its actual size, consisting of the 0 key and the Command (⌘) modifier.
    public static let zoomToActualSize = KeyboardAction.zoomToActualSize.keyboardShortcut

    /// A keyboard shortcut for a rewind action, consisting of the left arrow (←) key and the Command (⌘) modifier.
    public static let rewind = KeyboardAction.rewind.keyboardShortcut

    /// A keyboard shortcut for a fast-forward action, consisting of the right arrow (→) key and the Command (⌘) modifier.
    public static let fastForward = KeyboardAction.fastForward.keyboardShortcut
}

@available(iOS 13.0, *)
private extension UIKeyModifierFlags {
    var eventModifiers: EventModifiers {
        var eventModifiers: EventModifiers = []

        if self.contains(.command) {
            eventModifiers.insert(.command)
        }
        if self.contains(.numericPad) {
            eventModifiers.insert(.numericPad)
        }
        if self.contains(.shift) {
            eventModifiers.insert(.shift)
        }
        if self.contains(.control) {
            eventModifiers.insert(.control)
        }
        if self.contains(.alphaShift) {
            eventModifiers.insert(.capsLock)
        }

        return eventModifiers
    }
}
#endif
