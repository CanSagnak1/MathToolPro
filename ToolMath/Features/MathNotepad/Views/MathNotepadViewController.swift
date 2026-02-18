//
//  MathNotepadViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import Combine
import UIKit

class MathNotepadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let storage = NoteStorageService.shared
    private var cancellables = Set<AnyCancellable>()
    private var notes: [MathNote] = []

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()

    private let emptyStateLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 16, weight: .medium)
        l.textColor = Theme.Colors.secondaryText
        l.textAlignment = .center
        l.text = "No notes yet. Tap + to add one."
        l.isHidden = true
        return l
    }()

    private let fab = QuickActionOrb()  // Renamed from FloatingActionButton

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        title = "Math Notepad"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")

        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(fab)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        fab.translatesAutoresizingMaskIntoConstraints = false

        fab.onPrimaryAction = { [weak self] in
            self?.openeditor(for: nil)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            fab.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            fab.widthAnchor.constraint(equalToConstant: 56),
            fab.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    private func setupBindings() {
        storage.$notes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                self?.notes = notes
                self?.tableView.reloadData()
                self?.emptyStateLabel.isHidden = !notes.isEmpty
            }
            .store(in: &cancellables)
    }

    private func openeditor(for note: MathNote?) {
        let editor = NoteEditorViewController(note: note)
        navigationController?.pushViewController(editor, animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
                as? NoteCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: notes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openeditor(for: notes[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            storage.deleteNote(at: indexPath.row)
        }
    }
}

class NoteCell: UITableViewCell {

    private let containerView = ElevatedSurfaceView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 18, weight: .bold)
        l.textColor = Theme.Colors.textPrimary
        return l
    }()

    private let contentPreviewLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 14, weight: .regular)
        l.textColor = Theme.Colors.secondaryText
        l.numberOfLines = 2
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 12, weight: .medium)
        l.textColor = Theme.Colors.secondaryText
        l.textAlignment = .right
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentPreviewLabel)
        containerView.addSubview(dateLabel)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentPreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -16),

            contentPreviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentPreviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentPreviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentPreviewLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }

    func configure(with note: MathNote) {
        titleLabel.text = note.title
        contentPreviewLabel.text = note.content

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        dateLabel.text = formatter.string(from: note.lastModified)
    }
}
