//
//  SneakyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-15.
//

import SwiftUI

struct Particle {
    let origin: CGPoint
    let velocity: CGVector
    let size: CGFloat
    let color: Color
    let phase: Double

    func position(at date: Date, in size: CGSize) -> CGPoint {
        let t = date.timeIntervalSinceReferenceDate + phase
        let x = origin.x + velocity.dx * t
        let y = origin.y + velocity.dy * t
        return CGPoint(
            x: x.truncatingRemainder(dividingBy: size.width),
            y: y.truncatingRemainder(dividingBy: size.height)
        )
    }

    static func random() -> Particle {
        Particle(
            origin: CGPoint(
                x: .random(in: 0...400),
                y: .random(in: 0...800)
            ),
            velocity: CGVector(
                dx: .random(in: -6...6),
                dy: .random(in: -6...6)
            ),
            size: .random(in: 1.5...3.5),
            color: Color.white.opacity(.random(in: 0.4...0.9)),
            phase: .random(in: 0...1000)
        )
    }
}

import SwiftUI

struct SneakyView: View {
    @State private var activated = false
    @State private var particles: [Particle] = (0..<150).map { _ in Particle.random() }

    var body: some View {
        ZStack {
            Color.black
                .opacity(activated ? 1 : 0)
                .ignoresSafeArea()

            if activated {
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        for particle in particles {
                            let position = particle.position(at: timeline.date, in: size)
                            let rect = CGRect(
                                x: position.x,
                                y: position.y,
                                width: particle.size,
                                height: particle.size
                            )
                            context.fill(
                                Path(ellipseIn: rect),
                                with: .color(particle.color)
                            )
                        }
                    }
                }
                let finalText = """
                    Hey, congrats on finding the last Easter Egg.
                    Why not take a break and stare at the stars?
                    
                           _(__)_        V
                          '-e e -'__,--.__)
                           (o_o)        ) 
                              \\. /___.  |
                               ||| _)/_)/
                              //_(/_(/_(
                    """
                Text(finalText)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding()
                    .transition(.opacity)
            } else {
                let mainText = """
                    Definitely don't tap and hold the screen...
                    I'm sure that won't do you any good.
                    Not one bit.
                    
                    
                    ...yep. Totally no secrets here.
                    """
                Text(mainText)
            }
        }
        .contentShape(Rectangle())
        .onLongPressGesture(minimumDuration: 1.5) {
            withAnimation(.easeInOut(duration: 0.6)) {
                activated.toggle()
            }
        }
    }
}

#Preview {
    SneakyView()
}
