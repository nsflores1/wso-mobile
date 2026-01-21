//
//  AboutView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-23.
//

import SwiftUI
import Logging
import Shimmer

struct AboutView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = AboutViewModel()
    @Environment(AuthManager.self) private var authManager

    @AppStorage("secretEnabled") private var secretEnabled: Bool = false

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
            }
            List {
                Section("Lead Developers (2026-2027)") {
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14643))
                        }
                    } label: {
                        Text("Nathaniel Flores - nsf1@williams.edu")
                    }
                    NavigationLink {
                        AuthGate {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14774))
                        }
                    } label: {
                        Text("Charlie Tharas - cmt8@wiliams.edu")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14656))
                        }
                    } label: {
                        Text("Nathan Vosburg - nvj1@williams.edu")
                    }
                }
                Section("App Artists") {
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14916))
                        }
                    } label: {
                        Text("Emma Li - ebl2@williams.edu")
                    }
                }
                Section("Student Beta Testers") {
                    Text("Note: Beta testers are ranked by amount of times they used the app during the beta test. Beta testers must have logged in to the app at least once in order to qualify. Not all are shown; some have opted to remain anonymous.")
                        .italic(true)
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14643))
                        }
                    } label: {
                        Text("Nathaniel Flores - nsf1@williams.edu (595 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14049))
                        }
                    } label: {
                        Text("Jenna Shuffelton - jms13@williams.edu (316 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15508))
                        }
                    } label: {
                        Text("Addison Kiewert - amk12@williams.edu (244 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15585))
                        }
                    } label: {
                        Text("Tiffany Zheng - tz10@williams.edu (207 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16213))
                        }
                    } label: {
                        Text("Marlene Ruiz - mdr3@williams.edu (192 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14876))
                        }
                    } label: {
                        Text("Chris Pohlmann - cp15@williams.edu (189 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14737))
                        }
                    } label: {
                        Text("Alex Moon - ahm2@williams.edu (150 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14875))
                        }
                    } label: {
                        Text("Stella Leras - sl32@williams.edu (147 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16465))
                        }
                    } label: {
                        Text("Sarah Baker - sb25@williams.edu (142 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15915))
                        }
                    } label: {
                        Text("Alex Chao - ac48@williams.edu (98 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 13896))
                        }
                    } label: {
                        Text("Sam Drescher - srd6@williams.edu (96 Tests)")
                    }
                    Text("Cassie Aretsky - jsa1@williams.edu (86 Tests)")
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14661))
                        }
                    } label: {
                        Text("Lauren Hall - lkh3@williams.edu (80 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16096))
                        }
                    } label: {
                        Text("Grey Warren - gbw1@williams.edu (67 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15346))
                        }
                    } label: {
                        Text("Eleanor Race - epr3@williams.edu (62 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 13745))
                        }
                    } label: {
                        Text("Chiaka Leilah Duruaku - cjd4@williams.edu (61 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 13963))
                        }
                    } label: {
                        Text("Olivia Johnson - oj2@williams.edu (52 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14656))
                        }
                    } label: {
                        Text("Nathan Vosburg - nvj1@williams.edu (52 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14093))
                        }
                    } label: {
                        Text("Tasis Gemmill-Nexon - tsg2@williams.edu (50 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14154))
                        }
                    } label: {
                        Text("Leo Margolies - lsm4@williams.edu (50 Tests)")
                    }
                    Text("Elsie Qiu - (Williams Alumni) (44 Tests)")
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16531))
                        }
                    } label: {
                        Text("Kaileen So - kws4@williams.edu (42 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14742))
                        }
                    } label: {
                        Text("Eniola Olabode - eo6@williams.edu (40 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15758))
                        }
                    } label: {
                        Text("Dylan Shepherd - das8@williams.edu (31 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14113))
                        }
                    } label: {
                        Text("Eliana Zitrin - edz1@williams.edu (29 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14690))
                        }
                    } label: {
                        Text("Jack Allen Greenfield - jag21@williams.edu (27 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15538))
                        }
                    } label: {
                        Text("Amirjon Ulmasov - au2@williams.edu (25 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16295))
                        }
                    } label: {
                        Text("Desiree Flores - dgf2@williams.edu (25 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15004))
                        }
                    } label: {
                        Text("Kez Osei-Agyemang - ko6@williams.edu (25 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14703))
                        }
                    } label: {
                        Text("Peter Refermat - pdr1@williams.edu (25 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14017))
                        }
                    } label: {
                        Text("Ramio Ramirez - rr16@williams.edu (22 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14938))
                        }
                    } label: {
                        Text("Phaedra Salerno - pls4@williams.edu (22 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14184))
                        }
                    } label: {
                        Text("Sam Wexler - saw9@williams.edu (21 Tests)")
                    }
                    Text("Lucinda Shafer - les7@williams.edu (19 Tests)")
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15747))
                        }
                    } label: {
                        Text("Adhy Agarwala - aea3@williams.edu (14 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15677))
                        }
                    } label: {
                        Text("Faith Wendel - few2@williams.edu (13 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 16548))
                        }
                    } label: {
                        Text("Arjun Patel - amp20@williams.edu (12 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14884))
                        }
                    } label: {
                        Text("David Alfaro - daa2@williams.edu (10 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15056))
                        }
                    } label: {
                        Text("Nicolas Gonzalez - ng15@williams.edu (9 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15895))
                        }
                    } label: {
                        Text("Sarah Sousa - sfs6@williams.edu (9 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 12501))
                        }
                    } label: {
                        Text("Simon Socolow - sms12@williams.edu (8 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 13997))
                        }
                    } label: {
                        Text("Alexia King - amk10@williams.edu (5 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 13899))
                        }
                    } label: {
                        Text("Bri Kang - bmk6@williams.edu (4 Tests)")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 15435))
                        }
                    } label: {
                        Text("Logan Spaleta - ls24@williams.edu (3 Tests)")
                    }
                }
                Section("Special Mentions") {
                    Text("Anderson Flores (https://github.com/andersonf1), Jorge Flores, and Jennifer Flores, who also tested out the app over 148 times, contributed networking code and SQL advice, and provided moral support")
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 14046))
                        }
                    } label: {
                        Text("Dylan Safai - das5@williams.edu, for providing WSU's support to this app's development")
                    }
                    Text("Ye Shu - https://shuye.dev, for writing a bunch of useful documentation that made all of this possible")
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 5515))
                        }
                    } label: {
                        Text("Matthew Baya - mjb9@williams.edu, for helping to maintain WSO infrastructure and providing hardware")
                    }
                    NavigationLink {
                        AuthGate {
                            WSOProfileView(viewModel: WSOUserViewModel(userID: 9487))
                        }
                    } label: {
                        Text("Professor Dan Barowy - dwb1@williams.edu, for some code review and brainstorming of some app functionality")
                    }
                    Text("Aidan Lloyd-Tucker - aidanlloydtucker@gmail.com, for writing the prior app implementation, which I used as a baseline for this one")
                    Text("Xe Iaso - https://github.com/Xe, for allowing WSO to use her anti-AI scraping techniques to protect our backend")
                    Text("The one person at Apple Developers who actually knows what they're doing")
                    Text("The many WSO developers of yore, including Williams CSCI department member Lida Doret (whose code still runs on our servers over two decades later!)").italic(true)
                }
                // EASTER EGG
                if secretEnabled {
                    Text("Most importantly, WSO is made possible by users like you. Thank you!")
                    NavigationLink {
                        SneakyView()
                    } label: {
                        Text("Nothing to see here...")
                            .shimmering()
                    }
                } else {
                    NavigationLink {
                        EtherialView()
                    } label: {
                        Text("Most importantly, WSO is made possible by users like you. Thank you!")
                    }
                }
            }
            .task {
                logger.trace("Fetching WSO words...")
                await viewModel.loadWords()
                logger.trace("WSO words fetch complete")
            }
        }
    }
}

#Preview {
    AboutView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
