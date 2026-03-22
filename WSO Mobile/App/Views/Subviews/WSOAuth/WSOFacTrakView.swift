//
//  WSOFacTrakProfView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

// a view for showing the page for any given prof.

import SwiftUI
import Kingfisher
import Logging

struct WSOFacTrakOverviewView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

        // variables for the search box
    @State private var searchText: String = ""
    @State var items: [WSOFacTrakSearch] = []
    @State var itemCount: Int = 0
    @FocusState private var isFocused
        // task handle
    @State private var searchTask: Task<Void, Never>?

    @State private var viewModel = WSOFacTrakOverviewViewModel()

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
                    .navigationTitle("FacTrak")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search for profs and courses...", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .onChange(of: searchText) { _, newValue in
                                    searchTask?.cancel()
                                    searchTask = Task {
                                        try? await Task.sleep(for: .milliseconds(300))
                                        guard !Task.isCancelled else { return }
                                            // an empty result will always fail so don't do it
                                        if !searchText.isEmpty {
                                            do {
                                                let data = try await WSOFacTrakSearch(query: newValue)
                                                itemCount = data.count
                                                items = data
                                            } catch {
                                                logger.error("Failed to update search results: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                                .focused($isFocused)
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    isFocused = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            if isFocused {
                                Button {
                                    isFocused = false
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    if searchText.isEmpty {
                        Section {
                            ForEach(viewModel.data) { department in
                                WSOFacTrakCardView(department: department)
                            }
                        }
                    } else {
                        ForEach(items) { item in
                            WSOFacTrakSearchView(item: item)
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: items.count)
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
                    }.hapticTap(.light)
                }
            }
        }
        .navigationTitle("FacTrak")
        .listStyle(.sidebar)
        .modifier(NavSubtitleIfAvailable(subtitle: "Click a department to see more"))
    }
}


struct WSOFacTrakSearchView: View {
    let item: WSOFacTrakSearch

    var body: some View {
        if item.type == "professor" {
            NavigationLink(
                destination: WSOFacTrakProfView(
                    userViewModel: WSOUserViewModel(userID: item.id),
                    reviewsViewModel: WSOFacTrakReviewsViewModel(id: item.id, type: .Professor),
                    viewModel: WSOFacTrakProfViewModel(id: item.id),
                    id: item.id
                )
            ) {
                Image(systemName: "person")
                Text(item.value)
                Spacer()
            }
        } else if item.type == "area" {
            HStack {
                Image(systemName: "graduationcap")
                Text(item.value)
            }
        } else if item.type == "course" {
            NavigationLink(
                destination: WSOFacTrakCourseView(
                    viewModel: WSOFacTrakReviewsViewModel(id: item.id, type: .Course),
                    name: item.value,
                    id: item.id
                )
            ) {
                Image(systemName: "studentdesk")
                Text(item.value)
                Spacer()
            }
        }
    }
}

struct WSOFacTrakCardView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let department: WSOFacTrakAreasOfStudy

    var body: some View {
        NavigationLink(
            destination: WSOFacTrakAreaView(
                viewModel: WSOFacTrakAreaViewModel(id: department.id),
                name: department.abbreviation,
                id: department.id
            )
        ) {
                // markdown in Text field trick
            Text("\(department.name) - *\(department.abbreviation)*")
        }
    }
}

struct WSOFacTrakCourseView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let viewModel: WSOFacTrakReviewsViewModel
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
                    .navigationTitle("Course Page #\(id)")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    if let content = viewModel.data {
                        ForEach(content) { review in
                            Section {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(name)
                                        HStack {
                                            if let year = review.semesterYear {
                                                if let season = review.semesterSeason {
                                                    Text(verbatim: "(\(season.capitalized) of \(year))")
                                                } else {
                                                    Text(verbatim: "(\(year))")
                                                }
                                            } else {
                                                Text("(Unknown review semester)")
                                            }
                                        }
                                    }
                                    HStack {
                                        NavigationLink(
                                            destination: WSOFacTrakProfView(
                                                userViewModel: WSOUserViewModel(
                                                    userID: review.professorID,
                                                ),
                                                reviewsViewModel: WSOFacTrakReviewsViewModel(
                                                    id: review.professorID,
                                                    type: .Professor
                                                ),
                                                viewModel: WSOFacTrakProfViewModel(
                                                    id: review.professorID,
                                                ),
                                                id: review.professorID
                                            )
                                        ) {
                                            Image(systemName: "person")
                                            Text("View reviews for this professor...")
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(Color.secondary)
                                    }
                                        // TODO: fix this on backend and this fixes itself
                                    if review.totalAgree != 0 && review.totalDisagree != 0 {
                                        HStack {
                                            Image(systemName: "hand.thumbsdown.filled.hand.thumbsup")
                                            Text("Agree: \(review.totalAgree),")
                                            Text("Disagree: \(review.totalDisagree)")
                                        }
                                    }
                                    if review.flagged {
                                        HStack {
                                            Image(systemName: "exclamationmark.octagon")
                                            Text("(This review has been flagged)")
                                                .italic()
                                        }
                                    }
                                    Divider()
                                    HStack {
                                        Text(review.comment)
                                    }.padding()
                                    if review.wouldRecommendCourse != nil || review.wouldTakeAnother != nil {
                                        Divider()
                                        if let recommend = review.wouldRecommendCourse {
                                            if recommend {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *recommends* this course")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *does not recommend* this course")
                                                }
                                            }
                                        }

                                        if let another = review.wouldTakeAnother {
                                            if another {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *would* take more courses")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *would not* take more courses")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if content.isEmpty {
                            Text("(No reviews for this course)")
                        }
                    } else if let err = viewModel.error {
                        Group {
                            Text(err.localizedDescription).foregroundStyle(Color.red)
                            Text("""
                                    
                                The Web site you seek
                                cannot be located but
                                endless more exist.
                                """)
                        }.padding(20)
                    } else {
                        ProgressView()
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
                    }.hapticTap(.light)
                }
            }
        }
        .navigationTitle("\(name) Reviews")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}


struct WSOFacTrakProfView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let userViewModel: WSOUserViewModel
    let reviewsViewModel: WSOFacTrakReviewsViewModel
    let viewModel: WSOFacTrakProfViewModel
    let id: Int

    @State private var imageData: UIImage?

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
                         
                         Did you complete your FacTrak course review quota on desktop? If you did, and you can find this professor's page on the desktop site, please contact WSO for help.
                         """)
                        .navigationTitle("Professor Page #\(id)")

                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    Section {
                        VStack {
                            Group {
                                if let image = imageData {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .frame(width: 200, height: 200)
                                } else {
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }.loadingUserImage(for: viewModel.data?.unixID, into: $imageData)
                            HStack {
                                Text(userViewModel.data?.name ?? "Loading...").bold()
                                Text("(Professor)").italic()
                            }
                            if let title = viewModel.data?.title {
                                Text(title).font(.headline)
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        VStack(alignment: .leading) {
                            Text("**Total Reviews:** \(viewModel.data?.factrakSurveys.count.description ?? "N/A")")
                            if let rates = viewModel.ratings {
                                Text("- **\((rates.avgWouldRecommendCourse * 100.0).rounded().formatted())%** would recommend this professor's courses.")
                                Text("- **\((rates.avgWouldTakeAnother * 100.0).rounded().formatted())%** would take another course with this professor.")
                            }
                        }
                    }
                    if let content = viewModel.data {
                        ForEach(content.factrakSurveys, id: \.id) { review in
                            Section {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(review.course.areaOfStudy.abbreviation) \(review.course.number)")
                                        HStack {
                                            if let year = review.semesterYear {
                                                if let season = review.semesterSeason {
                                                    Text(verbatim: "(\(season.capitalized) of \(year))")
                                                } else {
                                                    Text(verbatim: "(\(year))")
                                                }
                                            } else {
                                                Text("(Unknown review semester)")
                                            }
                                        }
                                    }
                                    HStack {
                                        NavigationLink(
                                            destination: WSOFacTrakCourseView(
                                                viewModel: WSOFacTrakReviewsViewModel(
                                                    id: review.courseID,
                                                    type: .Course
                                                ),
                                                name: "\(review.course.areaOfStudy.abbreviation) \(review.course.number)",
                                                id: review.courseID
                                            )
                                        ) {
                                            Image(systemName: "studentdesk")
                                            Text("View reviews for this course...")
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(Color.secondary)
                                    }
                                    // TODO: fix this on backend and this fixes itself
                                    if review.totalAgree != 0 && review.totalDisagree != 0 {
                                        HStack {
                                            Image(systemName: "hand.thumbsdown.filled.hand.thumbsup")
                                            Text("Agree: \(review.totalAgree),")
                                            Text("Disagree: \(review.totalDisagree)")
                                        }
                                    }
                                    if review.flagged {
                                        HStack {
                                            Image(systemName: "exclamationmark.octagon")
                                            Text("(This review has been flagged)")
                                                .italic()
                                        }
                                    }
                                    Divider()
                                    HStack {
                                        Text(review.comment)
                                    }.padding()
                                    if review.wouldRecommendCourse != nil || review.wouldTakeAnother != nil {
                                        Divider()
                                        if let recommend = review.wouldRecommendCourse {
                                            if recommend {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *recommends* this course")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *does not recommend* this course")
                                                }
                                            }
                                        }

                                        if let another = review.wouldTakeAnother {
                                            if another {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *would* take more courses")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *would not* take more courses")
                                                }
                                            }

                                        }
                                    }
                                }
                            }
                        }
                        if content.factrakSurveys.isEmpty {
                            Text("(No reviews for this professor)")
                        }
                    } else if let err = reviewsViewModel.error {
                        Group {
                            Text(err.localizedDescription).foregroundStyle(Color.red)
                            Text("""
                                 
                                 The Web site you seek
                                 cannot be located but
                                 endless more exist.
                                 """)
                        }.padding(20)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchIfNeeded()
            await userViewModel.fetchIfNeeded()
            await reviewsViewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
            await userViewModel.forceRefresh()
            await reviewsViewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOFacTrakProfKeyView()) {
                        Image(systemName: "questionmark")
                    }.hapticTap(.light)
                }
            }
        }
        .navigationTitle("Professor Reviews")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}

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
                    }.hapticTap(.light)
                }
            }
        }
        .navigationTitle("\(name) Overview")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}

struct WSOFacTrakProfKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    This page is a Professor view, showing you the contents of a profesor's course reviews.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    The top of the page contains the overall review scores for a professor, followed by a scrollable list of reviews for you to inspect and read for further information.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    You can tap on any of the reviews to get a more comprehensive view of the entire course's reviews for any given professor.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                    let explanationText3 = """
                    To return to the home page after going many levels deep, tap the "Home" icon in the toolbar at the bottom of the screen.
                    """
                    Text(explanationText3.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Professor Page Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your FacTrak related needs"))
        }

    }
}

struct WSOFacTrakAreaKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    This page is an Area view, showing you the contents of an overall course area (either one course or many courses).
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    If this page covers many courses, you can scroll through both a list of professors and courses by department to get to what you're looking for quickly.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    You can tap on any course review to see its cooresponding professor, and vice versa.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                    let explanationText3 = """
                    To return to the home page after going many levels deep, tap the "Home" icon in the toolbar at the bottom of the screen.
                    """
                    Text(explanationText3.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Area Page Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your FacTrak related needs"))
        }

    }
}
