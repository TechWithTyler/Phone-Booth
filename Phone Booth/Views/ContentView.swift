//
//  ContentView.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/15/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
	
    @Query private var phones: [Phone]

	@State private var selectedPhone: Phone?

//	@State private var showingDeleteOne: Bool = false

	@State private var showingDeleteAll: Bool = false

	var body: some View {
		NavigationSplitView {
			ZStack {
				if !phones.isEmpty {
					List(selection: $selectedPhone) {
						ForEach(phones) { phone in
							NavigationLink(value: phone) {
								PhoneRowView(phone: phone)
//									.alert("Delete this phone?", isPresented: $showingDeleteOne, presenting: phone) { phone in
//										Button(role: .destructive) {
//											deletePhone(phone)
//											showingDeleteOne = false
//										} label: {
//											Text("Delete")
//										}
//										Button(role: .cancel) {
//											showingDeleteOne = false
//										} label: {
//											Text("Cancel")
//										}
//									} message: { phone in
//										Text("\(phone.brand) \(phone.model) will be deleted from your database.")
//									}
							}
							.contextMenu {
								Button {
									deletePhone(phone)
//									showingDeleteOne = true
								} label: {
									Label("Delete", image: "trash")
								}
							}
						}
						.onDelete(perform: deleteItems)
					}
				} else {
					Text("No phones")
						.font(.largeTitle)
						.foregroundStyle(Color.secondary)
				}
			}
			.toolbar {
#if os(iOS)
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
#endif
				ToolbarItem {
					Button(action: addItem) {
						Label("Add Phone", systemImage: "plus")
					}
				}
				ToolbarItem {
					Button(action: deleteAllPhones) {
						Label("Delete All", systemImage: "trash")
							.labelStyle(.titleAndIcon)
					}
				}
			}
		} detail: {
			if !phones.isEmpty {
				if let phone = selectedPhone {
					PhoneDetailView(phone: phone)
				} else {
					NoPhoneSelectedView()
				}
			} else {
				EmptyView()
			}
		}
    }

    private func addItem() {
        withAnimation {
			modelContext.insert(
				Phone(brand: "Some Brand", model: "M123")
			)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
//               showingDeleteOne = true
				deletePhone(phones[index])
            }
        }
    }

	func deletePhone(_ phone: Phone) {
		modelContext.delete(phone)
		selectedPhone = nil
	}

	func deleteAllPhones() {
		selectedPhone = nil
		for phone in phones {
			modelContext.delete(phone)
		}
	}
}

#Preview {
    ContentView()
        .modelContainer(for: Phone.self, inMemory: true)
}
