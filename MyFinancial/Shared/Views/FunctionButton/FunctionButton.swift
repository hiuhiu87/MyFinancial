//
//  FunctionButton.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct FunctionButtonProps<IconContent: View> {
    let icon: IconContent
    let title: String
    let action: () -> Void
}

struct FunctionButton<IconContent: View>: View {

    private let props: FunctionButtonProps<IconContent>
    @State private var isPressed = false
    @State private var isHovered = false

    var icon: IconContent { props.icon }
    var title: String { props.title }
    var action: () -> Void { props.action }

    init(props: FunctionButtonProps<IconContent>) {
        self.props = props
    }

    init(icon: IconContent, title: String, action: @escaping () -> Void = {}) {
        self.props = FunctionButtonProps(
            icon: icon,
            title: title,
            action: action
        )
    }

    var body: some View {
        Button(action: {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()

            // Execute action with slight delay for visual feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        }) {
            VStack(spacing: 8) {
                icon
                    .frame(maxWidth: 24, maxHeight: 24)
                    .scaleEffect(isPressed ? 0.85 : (isHovered ? 1.1 : 1.0))
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.6),
                        value: isPressed
                    )
                    .animation(.easeInOut(duration: 0.2), value: isHovered)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .opacity(isPressed ? 0.7 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: 82, maxHeight: 64)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(
                    color: .black.opacity(isHovered ? 0.15 : 0.08),
                    radius: isPressed ? 1 : (isHovered ? 8 : 3),
                    x: 0,
                    y: isPressed ? 1 : (isHovered ? 4 : 2)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.7),
                    value: isPressed
                )
                .animation(.easeInOut(duration: 0.2), value: isHovered)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: isPressed
        )
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    FunctionButton(
        props: FunctionButtonProps(
            icon: Image(systemName: "plus"),
            title: "Add",
            action: { print("Tapped!") }
        )
    )
}
