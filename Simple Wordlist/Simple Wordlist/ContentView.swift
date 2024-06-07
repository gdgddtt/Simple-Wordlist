//
//  ContentView.swift
//  Simple Wordlist
//
//  Created by Shennan Jiang1  on 6/7/24.
//

import SwiftUI
import CoreData

enum SortCriteria {
    case byWordAscending
    case byWordDescending
    case byDefinitionAscending
    case byDefinitionDescending
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddWordView = false
    @State private var sortCriteria: SortCriteria = .byWordAscending

    private var sortDescriptors: [SortDescriptor<Word>] {
        switch sortCriteria {
        case .byWordAscending:
            return [SortDescriptor(\Word.word, order: .forward)]
        case .byWordDescending:
            return [SortDescriptor(\Word.word, order: .reverse)]
        case .byDefinitionAscending:
            return [SortDescriptor(\Word.definition, order: .forward)]
        case .byDefinitionDescending:
            return [SortDescriptor(\Word.definition, order: .reverse)]
        }
    }

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Word.word, order: .forward)],
        animation: .default)
    private var words: FetchedResults<Word>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(words) { word in
                        VStack(alignment: .leading) {
                            Text(word.word ?? "Unknown")
                                .font(.headline)
                            Text(word.definition ?? "No definition")
                                .font(.subheadline)
                        }
                    }
                    .onDelete(perform: deleteWords)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Menu {
                                Button(action: { updateSortOrder(to: .byWordAscending) }) {
                                    Text("Sort by Word Ascending")
                                }
                                Button(action: { updateSortOrder(to: .byWordDescending) }) {
                                    Text("Sort by Word Descending")
                                }
                                Button(action: { updateSortOrder(to: .byDefinitionAscending) }) {
                                    Text("Sort by Definition Ascending")
                                }
                                Button(action: { updateSortOrder(to: .byDefinitionDescending) }) {
                                    Text("Sort by Definition Descending")
                                }
                            } label: {
                                Text("Sort")
                            }
                            Button(action: {
                                showAddWordView.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Word List")
            .sheet(isPresented: $showAddWordView) {
                AddWordView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteWords(offsets: IndexSet) {
        withAnimation {
            offsets.map { words[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func updateSortOrder(to criteria: SortCriteria) {
        var sortDescriptor: SortDescriptor<Word>

        switch criteria {
        case .byWordAscending:
            sortDescriptor = SortDescriptor(\Word.word, order: .forward)
        case .byWordDescending:
            sortDescriptor = SortDescriptor(\Word.word, order: .reverse)
        case .byDefinitionAscending:
            sortDescriptor = SortDescriptor(\Word.definition, order: .forward)
        case .byDefinitionDescending:
            sortDescriptor = SortDescriptor(\Word.definition, order: .reverse)
        }

        words.sortDescriptors = [sortDescriptor]
    }
}
