//
//  NoteEditorViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

class NoteEditorViewController: UIViewController {

    private var note: MathNote?
    private let storage = NoteStorageService.shared

    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.font = Theme.Fonts.display(size: 24, weight: .bold)
        tf.textColor = Theme.Colors.textPrimary
        return tf
    }()

    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = Theme.Fonts.display(size: 16, weight: .regular)
        tv.textColor = Theme.Colors.textPrimary
        tv.backgroundColor = .clear
        return tv
    }()

    init(note: MathNote?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            titleTextField.becomeFirstResponder()
        }
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveTapped))

        view.addSubview(titleTextField)
        view.addSubview(contentTextView)

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),

            contentTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }

    @objc private func saveTapped() {
        let title = titleTextField.text ?? "Untitled"
        let content = contentTextView.text ?? ""

        if var note = note {
            note.title = title
            note.content = content
            storage.updateNote(note)
        } else {
            storage.addNote(title: title, content: content)
        }

        navigationController?.popViewController(animated: true)
    }
}
