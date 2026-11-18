import SwiftUI

struct AnimatedChangesModifier<Value: Equatable>: ViewModifier {
    let value: Value

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? nil : .default, value: value)
    }
}

extension View {
    func animatesChanges(of value: some Equatable) -> some View {
        modifier(AnimatedChangesModifier(value: value))
    }
}

private struct AnimatedChangesPreview: View {
    @State private var items = ["Kraków", "Łódź", "Singapore"]

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Button {
                    items.removeAll { $0 == item }
                    items.insert(item, at: 0)
                } label: {
                    Text(verbatim: item)
                }
            }
        }
        .animatesChanges(of: items)
    }
}

#Preview("Moving a row to the top") {
    AnimatedChangesPreview()
}
