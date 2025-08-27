//@ pragma UseQApplication
import Quickshell
import qs.bar

Variants {
    model: Quickshell.screens

    Scope {
        required property var modelData

        Bar {
            screen: modelData
        }
    }
}
