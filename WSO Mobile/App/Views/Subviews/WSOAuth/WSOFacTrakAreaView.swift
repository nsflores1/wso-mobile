//
//  WSOFacTrakAreaView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-20.
//

// a view for showing the page for any given course.

import SwiftUI
import Kingfisher
import Logging

struct WSOFacTrakAreaView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let viewModel: WSOFacTrakAreaViewModel
    let name: String
    let id: Int

    var body: some View {
        NavigationStack {
            if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription)
                        .foregroundStyle(Color.red)
                    Text("""
                         
                         Your attempt to access FacTrak has failed (probably due to not completing your review quota).
                         
                         You step in the stream,
                         but the water has moved on.
                         This page is not here.
                         
                         Did you complete your FacTrak course review quota on desktop? If you did, and you can find this course's page on the desktop site, please contact WSO for help.
                         """)
                        .navigationTitle("Dept. Page #\(id)")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    Section {
                        if let professor = viewModel.professors {
                            ForEach(professor.sorted(), id: \.self) { prof in
                                NavigationLink(
                                    destination: WSOFacTrakProfView(
                                        userViewModel: WSOUserViewModel(
                                            userID: prof.id
                                        ),
                                        reviewsViewModel: WSOFacTrakReviewsViewModel(
                                            id: prof.id,
                                            type: .Professor
                                        ),
                                        viewModel: WSOFacTrakProfViewModel(id: prof.id),
                                        id: prof.id
                                    )
                                ) {
                                    VStack(alignment: .leading) {
                                        Text(prof.name)
                                        if let title = prof.title {
                                            Text(title)
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }
                                }
                            }
                            if professor.isEmpty {
                                Text("(No profs in this department)")
                            }
                        } else if let err = viewModel.error {
                            Group {
                                Text(err.localizedDescription).foregroundStyle(Color.red)
                                Text("""
                                    
                                    The Web site you seek
                                    cannot be located but
                                    endless more exist.
                                    """)
                            }.refreshable {
                                await viewModel.forceRefresh()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }.padding(20)
                        } else {
                            ProgressView()
                        }
                    } header: {
                        Text("Professors")
                    }
                    Section {
                        // TODO: this whole course thing is one massive hack,
                        // unfortunately there's still no good API for fetching this from backend...
                        if let course = viewModel.courses {
                            ForEach(course.sorted(), id: \.self) { course in
                                NavigationLink(
                                    destination: WSOFacTrakCourseView(
                                        viewModel: WSOFacTrakReviewsViewModel(
                                            id: course.id,
                                            type: .Course
                                        ),
                                        name: "\(name) \(course.number)",
                                        id: course.id
                                    )
                                ) {
                                    HStack {
                                        Text("\(name) \(course.number)")
                                    }
                                }
                            }
                            if course.isEmpty {
                                Text("(No courses in this deparment)")
                            }
                        } else if let err = viewModel.error {
                            Group {
                                Text(err.localizedDescription).foregroundStyle(Color.red)
                                Text("""
                                    
                                    The Web site you seek
                                    cannot be located but
                                    endless more exist.
                                    """)
                            }.refreshable {
                                await viewModel.forceRefresh()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }.padding(20)
                        } else {
                            ProgressView()
                        }
                    } header: {
                        Text("Courses")
                    }
                }
            }
        }
        .task {
            await viewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOFacTrakAreaKeyView()) {
                        Image(systemName: "questionmark")
                    }.simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                }
            }
        }
        .navigationTitle("\(name) Overview")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}
