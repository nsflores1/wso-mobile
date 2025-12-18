//
//  AboutView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-23.
//

import SwiftUI

struct AboutView: View {
    @State private var viewModel = AboutViewModel()
    let impact = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        NavigationStack {
            VStack {
                Text("WSO Mobile")
                    .font(.title)
                    .fontWeight(.bold)
                    // TODO: secretly make this a button as an easter egg
                if viewModel.isLoading {
                    Text("Rolling dice...")
                        .font(.headline)
                        .fontWeight(.medium)
                        .italic(true)
                } else {
                    Text(viewModel.words)
                        .font(.headline)
                        .fontWeight(.medium)
                        .italic(true)
                }
                Divider().tint(Color(.secondarySystemBackground))
                let text = """
                WSO is made possible by the following lovely people,
                 who all contributed greatly:
                """
                Text(text.replacingOccurrences(of: "\n", with: ""))
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: SneakyView()) {
                            Image(systemName: "questionmark")
                        }
                    }.onTapGesture {
                        impact.impactOccurred()
                    }
                }
            }
            List {
                Section("Lead Developers (2026-2027)") {
                    Text("Nathaniel Flores - nsf1@williams.edu")
                    Text("Charlie Tharas - cmt8@wiliams.edu")
                    Text("Nathan Vosburg - nvj1@williams.edu")
                }
                Section("App Artists") {
                    Text("Emma Li - ebl2@williams.edu")
                }
                Section("Student Beta Testers") {
                    Text("Note: Beta testers are not ranked in any particular order")
                        .italic(true)
                    Text("Eleanor Race - epr3@williams.edu")
                    Text("Leo Margolies - lsm4@williams.edu")
                    Text("Tasis Gemmill-Nexon - tsg2@williams.edu")
                    Text("Olivia Johnson - oj2@williams.edu")
                    Text("Kaileen So - kws4@williams.edu")
                    Text("Dylan Sheperd - das8@williams.edu")
                    Text("Peter Refermat - pdr1@williams.edu")
                    Text("David Alfaro - daa2@williams.edu")
                    Text("Ramio Ramirez - rr16@williams.edu")
                    Text("Arjun Patel - amp20@williams.edu")
                    Text("Nicolas Gonzalez - ng15@williams.edu")
                    Text("Alexia King - amk10@williams.edu")
                    Text("Bri Kang - bmk6@williams.edu")
                    Text("Logan Spaleta - ls24@williams.edu")
                    Text("Olivia Thorton - ort1@williams.edu")
                    Text("Andrew Gu - amg11@williams.edu")
                    Text("Jenna Shuffleton - jms13@williams.edu")
                    Text("Addison Kiewert - amk12@williams.edu")
                    Text("Alex Chao - ac48@williams.edu")
                    Text("Alex Moon - ahm2@williams.edu")
                    Text("Tiffany Zheng - tz10@williams.edu")
                    Text("Marlene Ruiz - mdr3@williams.edu")
                    Text("Chris Pohlmann - cp15@williams.edu")
                    Text("Grey Warren - gbw1@williams.edu")
                    Text("Stella Leras - sl32@williams.edu")
                    Text("Cassie Aretsky - jsa1@williams.edu")
                    Text("Sarah Baker - sb25@williams.edu")
                    Text("Sam Drescher - srd6@williams.edu")
                    Text("Lauren Hall - lkh3@williams.edu")
                    Text("Chiaka Leilah Duruaku - cjd4@williams.edu")
                    Text("Kez Osei-Agyemang - ko6@williams.edu")
                    Text("Jack Allen - jag21@williams.edu")
                    Text("Sam Wexler - saw9@williams.edu")
                    Text("Eliana Zitrin - edz1@williams.edu")
                    Text("Adhy Agarwala - aea3@williams.edu")
                    Text("Desiree Flores - dgf2@williams.edu")
                    Text("Lucinda Shafer - les7@williams.edu")
                    Text("Phaedra Salerno - pls4@williams.edu")
                    Text("Amirjon Ulmasov - au2@williams.edu")
                    Text("Sarah Sousa - sfs6@williams.edu")
                    Text("Faith Wendel - few2@williams.edu")
                    Text("Eniola Olabode - eo6@williams.edu")
                    Text("Simol Socolow - sms12@williams.edu")
                }
                Section("Special Mentions") {
                    Text("Dylan Safai - das5@williams.edu")
                    Text("Ye Shu - https://shuye.dev")
                    Text("Matthew Baya - mjb9@williams.edu")
                    Text("Aidan Lloyd-Tucker - aidanlloydtucker@gmail.com")
                    Text("The many WSO developers of yore").italic(true)
                }
                NavigationLink("WSO is made possible by users like you. Thank you!") {
                    EtherialView()
                }.onTapGesture {
                    impact.impactOccurred()
                }
            }
            .task { await viewModel.loadWords() }
        }
    }
}

#Preview {
    AboutView()
}
