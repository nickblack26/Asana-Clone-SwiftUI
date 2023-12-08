import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var tasks: [TaskModel]
	@State private var taskTab: String = "Upcoming"
	@State private var selectedTask: TaskModel? = nil
	@State private var openSheet: Bool = false
	@State private var showInspector: Bool = false
	@State private var colorScheme: ColorScheme = .white
	@Environment(\.colorScheme) var backgroundColor
		
	func getFormattedDate() -> String {
		let today = Date()
		let calendar = Calendar.current
		let f = DateFormatter()
		
		let day = f.weekdaySymbols[calendar.component(.weekday, from: today) - 1]
		let month = f.monthSymbols[calendar.component(.month, from: today) - 1]
		let dayNum = calendar.component(.day, from: today)
		
		return "\(day), \(month) \(dayNum)"
	}
	
	func getIndices(_ row: Int) -> (Int, Int) {
		let count = defaultWidgets.count
		var start = row * 2
		var end = start + 2
		
		if(start > count) {
			if(start - 1 == count) {
				start -= 1
				end -= 1
				return (start, end)
			}
		}
		
		if(end > count) {
			end -= 1
		}
		
		return (start, end)
		
	}
	
	var body: some View {
		VStack {
			VStack {
				Text("\(getFormattedDate())")
					.font(.title3)
					.fontWeight(.medium)
				
				Text("Good afternoon, Nick")
					.font(.largeTitle)
					.fontWeight(.regular)
			}
			
			HStack {
				Spacer()
				Spacer()
				
                AchievmentsWidgetView(number: tasks.count, collaborators: 1)
				
				Spacer()
				
				Button {
					showInspector.toggle()
				} label: {
					Label("Customize", systemImage: "rectangle.badge.plus")
				}
				.buttonStyle(.plain)
				.padding(.horizontal)
				.padding(.vertical, 10)
				.background {
					RoundedRectangle(cornerRadius: 5)
						.stroke(.cardBorder, lineWidth: 1)
						.fill(.cardBackground)
				}
			}
			
			LazyVGrid(columns: [GridItem(),GridItem()], spacing: 0) {
				ForEach(defaultWidgets) { widget in
					ZStack {
//						switch widget.type {
//							case .myTasks:
//								Text(widget.name)
//							case .people:
//								Text(widget.name)
//							case .projects:
//								Text(widget.name)
//							case .notepad:
//								Text(widget.name)
//							case .tasksAssigned:
//								Text(widget.name)
//							case .draftComments:
//								Text(widget.name)
//							case .forms:
//								Text(widget.name)
//							case .myGoals:
//								Text(widget.name)
//								
//						}
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
					.dropDestination(for: WidgetOptionModel.self) { items, location in
						return false
					} isTargeted: { status in
						let option = widget
						
						
//						if let draggingItem, status, draggingItem != option {
//								if let sourceIndex = vm.availableWidgets.firstIndex(of: draggingItem), let destinationIndex = vm.homeWidgets.firstIndex(of: vm.homeWidgets[index]) {
//									withAnimation {
//										let sourceItem = vm.availableWidgets.remove(at: sourceIndex)
//										vm.homeWidgets.insert(sourceItem, at: destinationIndex)
//									}
//								}
//						}
					}
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		}
		.padding()
		.frame(maxWidth: 1200)
		.sheet(isPresented: $openSheet) {
			NavigationStack {
				if let task = selectedTask {
					VStack {
						Text(task.name)
					}
				} else {
					ContentUnavailableView {
						Image(systemName: "magnifyingglass.circle")
					} description: {
						Text("Select a suspect to inspect")
					} actions: {
						Text("Fill out details from the interview")
					}
				}
			}
		}
		.navigationTitle("Home")
		.background {
			if(backgroundColor == .dark && colorScheme == .white) {
				Image("\(colorScheme.preferences.image)_background")
					.resizable()
					.scaledToFill()
					.edgesIgnoringSafeArea(.all)
			} else if (colorScheme != .white) {
				Image("\(colorScheme.preferences.image)_background")
					.resizable()
					.scaledToFill()
					.edgesIgnoringSafeArea(.all)
			}
		}
	}
}

#Preview {
	NavigationStack {
		ScrollView {
			HomeView()
		}
	}
}
