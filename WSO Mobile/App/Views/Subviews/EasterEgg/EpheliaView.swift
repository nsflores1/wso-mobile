//
//  EpheliaView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct EpheliaView: View {
    @State private var isPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Image("EpheliaPicture")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                Text("* Ephelia stands on Stone Hill, before you.").italic(true)
                Button("Recieve Her Wisdom") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    isPresented.toggle()
                }
                .buttonStyle(.borderedProminent)
                if (isPresented) {
                    Text("* She says: \"Silence answers all questions.\"").italic(true)
                    Text("* You wonder why you traveled all the way to this hidden Easter Egg screen, just to have your time wasted...").italic(true)
                }
            }.padding(20)
                .navigationTitle(Text("Wrong Section???"))
        }
    }
}

#Preview {
    EpheliaView()
}
