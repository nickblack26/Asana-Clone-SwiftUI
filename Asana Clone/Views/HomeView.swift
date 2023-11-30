//
//  HomeView.swift
//  Asana Clone
//
//  Created by Nick on 6/22/23.
//

import SwiftUI

struct HomeView: View {
	@State private var vm = HomeViewModel.shared
	@State private var taskTab: String = "Upcoming"
	@State private var selectedTask: PublicTasksModel? = nil
	@State private var openSheet: Bool = false
	@State private var showInspector: Bool = false
	@State private var colorScheme: ColorScheme = .white
	@Environment(\.colorScheme) var backgroundColor
	
	//	@Environment(UserDefaultsViewModel.self) private var userDefaults
	
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
				
				AchievmentsWidgetView(number: 1, collaborators: 1)
				
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
			
			Grid(horizontalSpacing: 15, verticalSpacing: 15) {
				ForEach(0..<3, id: \.self) { row in
					GridRow {
						ForEach(getIndices(row).0 ..< getIndices(row).1, id: \.self) { index in
							Text("Hello")
								.gridCellColumns(defaultWidgets[index].columns)
								.dropDestination(for: WidgetOptionModel.self) { items, location in
									return false
								} isTargeted: { status in
									let option = defaultWidgets[index]
									let draggingItem = vm.draggingItem
									
									
									if let draggingItem, status, draggingItem != option {
										if let sourceIndex = vm.availableWidgets.firstIndex(of: draggingItem), let destinationIndex = vm.homeWidgets.firstIndex(of: vm.homeWidgets[index]) {
											withAnimation {
												let sourceItem = vm.availableWidgets.remove(at: sourceIndex)
												vm.homeWidgets.insert(sourceItem, at: destinationIndex)
											}
										}
									}
								}
						}
					}
				}
			}
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