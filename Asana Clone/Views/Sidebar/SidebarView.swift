import SwiftUI
import SwiftData

enum ProjectSortOption: String, CaseIterable {
    case Alphabetical
    case Recent
    case Top
}

enum SidebarLink: Hashable {
    case home
    case myTasks
    case inbox
    case reporting
    case portfolios
    case goals
    case project(ProjectModel)
    case team(UUID)
}

struct SidebarView: View {
    @Environment(AsanaManager.self) private var asanaManager
    @Query private var projects: [ProjectModel]
    @Query private var teams: [TeamModel]
    @State private var selectedSort: ProjectSortOption = .Recent
    @State private var newDashboard: Bool = false
    @State private var newPortfolio: Bool = false
    @State private var newProject: Bool = false
    @State private var newGoal: Bool = false
    
    var body: some View {
        @Bindable var asanaManager = asanaManager
        
        List(selection: $asanaManager.selectedLink) {
            NavigationLink(value: SidebarLink.home) {
                Label("Home", systemImage: "house")
            }
            
            NavigationLink(value: SidebarLink.myTasks) {
                Label("My Tasks", systemImage: "checkmark.circle")
            }
            
            NavigationLink(value: SidebarLink.inbox) {
                Label("Inbox", systemImage: "bell")
            }
            
            Divider()
            
            DisclosureGroup(isExpanded: .constant(true)) {
                NavigationLink(value: SidebarLink.reporting) {
                    Label("Reporting", systemImage: "chart.xyaxis.line")
                }
                NavigationLink(value: SidebarLink.portfolios) {
                    Label("Portfolios", systemImage: "folder")
                }
                NavigationLink(value: SidebarLink.goals) {
                    Label("Goals", systemImage: "mountain.2")
                }
            } label: {
                HStack {
                    Text("Insights")
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            newDashboard.toggle()
                        } label: {
                            Label("New dashboard", systemImage: "chart.xyaxis.line")
                        }
                        
                        Button {
                            newPortfolio.toggle()
                        } label: {
                            Label("New portfolio", systemImage: "folder")
                        }
                        
                        Button {
                            newGoal.toggle()
                        } label: {
                            Label("New goal", systemImage: "mountain.2")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.callout)
                    }
                }
            }
            
            DisclosureGroup(isExpanded: .constant(true)) {
                ForEach(projects) { project in
                    NavigationLink(value: SidebarLink.project(project)) {
                        Label {
                            Text(project.name)
                                .lineLimit(1)
                        } icon: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(project.color.color)
                                .frame(width: 25, height: 25)
                                .overlay(alignment: .bottomTrailing) {
                                    if (project.privacy == .privateToMe) {
                                        Image(systemName: "lock.fill")
                                    }
                                }
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Projects")
                    
                    Menu {
                        Section("Sort projects and portfolios") {
                            ForEach(ProjectSortOption.allCases, id: \.self) { option in
                                Button {
                                    selectedSort = option
                                } label: {
                                    Label(option.rawValue, systemImage: selectedSort == option ? "checkmark" : "")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.callout)
                    }
                    
                    Menu {
                        Button {
                            newProject.toggle()
                        } label: {
                            Label("New project", systemImage: "list.bullet.clipboard")
                        }
                        
                        Button {
                            
                        } label: {
                            Label("New portfolio", systemImage: "folder")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.callout)
                    }
                }
            }
            
            DisclosureGroup("Team", isExpanded: .constant(true)) {
                ForEach(teams) { team in
                    NavigationLink(value: SidebarLink.team(UUID())) {
                        Label(team.name, systemImage: "person.2.fill")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
        }
        .fullScreenCover(isPresented: $newProject, content: {
            NavigationStack {
                NewProjectView(isPresented: $newProject)
                    .toolbar {
                        ToolbarItem {
                            Button {
                                newProject.toggle()
                            } label: {
                                Label("Close", systemImage: "xmark")
                            }
                        }
                    }
            }
        })
        .sheet(isPresented: $newDashboard) {
            NewDashboardModal()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Add chart")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    ToolbarItem {
                        Button {
                            newDashboard.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
        .sheet(isPresented: $newPortfolio) {
            NewDashboardModal()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Add chart")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    ToolbarItem {
                        Button {
                            newPortfolio.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
        .sheet(isPresented: $newGoal) {
            NewDashboardModal()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Add chart")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    ToolbarItem {
                        Button {
                            newGoal.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
        .navigationSplitViewColumnWidth(min: 240, ideal: 300, max: 400)
        
        //			if(!manager.starredProjects.isEmpty) {
        //				DisclosureGroup {
        //					ForEach(manager.starredProjects) { starred in
        //						NavigationLink(value: SidebarLink.project(starred.project_id.id)) {
        //							Label {
        //								Text(starred.project_id.name)
        //							} icon: {
        //								ZStack(alignment: .bottomTrailing) {
        //									RoundedRectangle(cornerRadius: 5)
        //										.fill(.pink)
        //										.frame(width: 20, height: 20)
        //									if (starred.project_id.is_private != nil && starred.project_id.is_private == true) {
        //										Image(systemName: "lock.fill")
        //									}
        //								}
        //							}
        //						}
        //					}
        //				} label: {
        //					HStack {
        //						Text("Starred")
        //						Button {
        //
        //						} label: {
        //							Image(systemName: "ellipsis")
        //						}
        //						.buttonStyle(.plain)
        //
        //						Button {
        //
        //						} label: {
        //							Image(systemName: "plus")
        //						}
        //						.buttonStyle(.plain)
        //					}
        //				}
        //			}
        
    }
}


#Preview {
    return NavigationSplitView {
        SidebarView()
    } detail: {
        EmptyView()
    }
    .modelContainer(for: ProjectModel.self, inMemory: true)
}
