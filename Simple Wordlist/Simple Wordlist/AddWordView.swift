//
//  AddWordView.swift
//  Simple Wordlist
//
//  Created by Shennan Jiang on 6/7/24.
//

import SwiftUI

struct AddWordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var word: String = ""
    @State private var definition: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word")) {
                    TextField("Enter word", text: $word)
                }
                Section(header: Text("Definition")) {
                    TextField("Enter definition", text: $definition)
                }
            }
            .navigationTitle("Add Word")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                addWord()
            })
        }
    }

    private func addWord() {
        let newWord = Word(context: viewContext)
        newWord.word = word
        newWord.definition = definition

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}
