//
//  PetView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-05.
//

import SwiftUI
import Combine
import FluidGradient

struct DesktopPetModifier: ViewModifier {
    @State private var petPosition = CGPoint(x: 200, y: 200)
    @State private var targetPosition: CGPoint?
    @State private var isWalking = false
    @State private var animationFrame = 0
    @State private var facingDirection = CGVector(dx: 1, dy: 0)

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    func body(content: Content) -> some View {
        ZStack {
            content
                .contentShape(Rectangle())
                .onTapGesture { location in
                    targetPosition = location
                    isWalking = true
                }

            petSprite
                .position(petPosition)
                .onReceive(timer) { _ in
                    updatePetPosition()
                }
        }
    }

    private var petSprite: some View {
            // sprite rendering logic goes here
        // this is where sprite logic should go, kupo!
        // kupokupokupo!
        Image(systemName: "hare.fill") // placeholder
            .rotationEffect(.degrees(facingDirection.dx < 0 ? 180 : 0))
            .imageScale(.large)
    }

    private func updatePetPosition() {
        guard let target = targetPosition, isWalking else { return }

        let dx = target.x - petPosition.x
        let dy = target.y - petPosition.y
        let distance = sqrt(dx*dx + dy*dy)

        if distance < 2 {
            petPosition = target
            targetPosition = nil
            isWalking = false
            return
        }

        let speed: CGFloat = 6.0
        facingDirection = CGVector(dx: dx, dy: dy)
        petPosition.x += (dx / distance) * speed
        petPosition.y += (dy / distance) * speed

        animationFrame = (animationFrame + 1) % 8 // cycle your frames
    }
}

extension View {
    func desktopPet() -> some View {
        modifier(DesktopPetModifier())
    }
}

struct EasterEggView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                FluidGradient(blobs: [.red, .green, .blue],
                              highlights: [.yellow, .orange, .purple],
                              speed: 1.0,
                              blur: 0.75)
                .background(.quaternary)
                Text("Tap anywhere to demo the feature...")
                    .italic(true)
                    .padding(20)
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .navigationTitle("Easter Egg")
            .modifier(NavSubtitleIfAvailable(subtitle: "This is a gross waste of dev time"))
        }
        .desktopPet()
    }
}

#Preview {
    EasterEggView()
}
