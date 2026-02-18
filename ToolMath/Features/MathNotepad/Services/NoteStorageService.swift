//
//  NoteStorageService.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import Combine
import Foundation

class NoteStorageService {

    static let shared = NoteStorageService()

    @Published private(set) var notes: [MathNote] = []

    private let key = "math_notes_storage"

    private init() {
        loadNotes()
    }

    func addNote(title: String, content: String) {
        let note = MathNote(title: title, content: content)
        notes.insert(note, at: 0)
        saveNotes()
    }

    func updateNote(_ note: MathNote) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            notes[index].lastModified = Date()
            // Move to top
            let updatedNote = notes.remove(at: index)
            notes.insert(updatedNote, at: 0)
            saveNotes()
        }
    }

    func deleteNote(at index: Int) {
        notes.remove(at: index)
        saveNotes()
    }

    private func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: key),
            let savedNotes = try? JSONDecoder().decode([MathNote].self, from: data)
        {
            self.notes = savedNotes
        }
    }
}
