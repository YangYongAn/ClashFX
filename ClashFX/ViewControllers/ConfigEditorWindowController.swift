import Cocoa

class ConfigEditorWindowController: NSWindowController {
    private var textView: NSTextView!
    private var scrollView: NSScrollView!
    private var filePath: String = ""
    private var toolbar: NSToolbar!
    private var statusLabel: NSTextField!
    private var filePopup: NSPopUpButton!

    static func show(configPath: String? = nil) {
        let controller = ConfigEditorWindowController()
        controller.showWindow(nil)
        if let path = configPath {
            controller.loadFile(path: path)
        } else {
            controller.loadCurrentConfig()
        }
        controller.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "ClashFX Config Editor"
        window.center()
        window.minSize = NSSize(width: 600, height: 400)
        super.init(window: window)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupUI() {
        guard let contentView = window?.contentView else { return }

        let topBar = NSView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topBar)

        filePopup = NSPopUpButton(frame: .zero, pullsDown: false)
        filePopup.translatesAutoresizingMaskIntoConstraints = false
        filePopup.target = self
        filePopup.action = #selector(fileSelectionChanged(_:))
        topBar.addSubview(filePopup)
        populateFileList()

        let saveBtn = NSButton(title: NSLocalizedString("Save", comment: ""), target: self, action: #selector(saveFile))
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.bezelStyle = .rounded
        saveBtn.keyEquivalent = "s"
        saveBtn.keyEquivalentModifierMask = .command
        topBar.addSubview(saveBtn)

        let reloadBtn = NSButton(title: NSLocalizedString("Save & Reload", comment: ""), target: self, action: #selector(saveAndReload))
        reloadBtn.translatesAutoresizingMaskIntoConstraints = false
        reloadBtn.bezelStyle = .rounded
        topBar.addSubview(reloadBtn)

        statusLabel = NSTextField(labelWithString: "")
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 11)
        statusLabel.textColor = .secondaryLabelColor
        topBar.addSubview(statusLabel)

        scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        contentView.addSubview(scrollView)

        textView = NSTextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isRichText = false
        textView.usesFindBar = true
        textView.isIncrementalSearchingEnabled = true
        if #available(macOS 10.15, *) {
            textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        } else {
            textView.font = NSFont(name: "Menlo", size: 13) ?? NSFont.systemFont(ofSize: 13)
        }
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.autoresizingMask = [.width]
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isHorizontallyResizable = true
        textView.isVerticallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.delegate = self

        if #available(macOS 10.14, *) {
            textView.backgroundColor = NSColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
            textView.insertionPointColor = .white
        }

        scrollView.documentView = textView

        let lineNumberView = LineNumberRulerView(textView: textView)
        scrollView.verticalRulerView = lineNumberView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            topBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            topBar.heightAnchor.constraint(equalToConstant: 32),

            filePopup.leadingAnchor.constraint(equalTo: topBar.leadingAnchor),
            filePopup.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            filePopup.widthAnchor.constraint(lessThanOrEqualToConstant: 200),

            saveBtn.trailingAnchor.constraint(equalTo: reloadBtn.leadingAnchor, constant: -8),
            saveBtn.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),

            reloadBtn.trailingAnchor.constraint(equalTo: topBar.trailingAnchor),
            reloadBtn.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: filePopup.trailingAnchor, constant: 12),
            statusLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: saveBtn.leadingAnchor, constant: -12),

            scrollView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func populateFileList() {
        filePopup.removeAllItems()
        let configs = ConfigManager.getConfigFilesList()
        for name in configs {
            filePopup.addItem(withTitle: name)
        }
        filePopup.selectItem(withTitle: ConfigManager.selectConfigName)
    }

    private func loadCurrentConfig() {
        let name = ConfigManager.selectConfigName
        let path = Paths.localConfigPath(for: name)
        loadFile(path: path)
    }

    func loadFile(path: String) {
        filePath = path
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            textView.string = content
            highlightYAML()
            let fileName = (path as NSString).lastPathComponent
            window?.title = "ClashFX Config Editor — \(fileName)"
            statusLabel.stringValue = "\(content.components(separatedBy: "\n").count) lines"
        } catch {
            textView.string = "// Error loading file: \(error.localizedDescription)"
            statusLabel.stringValue = "Error"
        }
    }

    @objc private func fileSelectionChanged(_ sender: NSPopUpButton) {
        guard let name = sender.selectedItem?.title else { return }
        let path = Paths.localConfigPath(for: name)
        loadFile(path: path)
    }

    @objc private func saveFile() {
        guard !filePath.isEmpty else { return }
        do {
            try textView.string.write(toFile: filePath, atomically: true, encoding: .utf8)
            statusLabel.stringValue = NSLocalizedString("Saved", comment: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                self.statusLabel.stringValue = "\(self.textView.string.components(separatedBy: "\n").count) lines"
            }
        } catch {
            let alert = NSAlert(error: error)
            alert.runModal()
        }
    }

    @objc private func saveAndReload() {
        saveFile()
        let configName = filePopup.selectedItem?.title ?? ConfigManager.selectConfigName
        AppDelegate.shared.updateConfig(configName: configName)
    }

    // MARK: - YAML Syntax Highlighting

    func highlightYAML() {
        let text = textView.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        let storage = textView.textStorage!

        storage.beginEditing()

        storage.addAttribute(.foregroundColor, value: NSColor(red: 0.85, green: 0.85, blue: 0.87, alpha: 1.0), range: fullRange)
        let monoFont: NSFont
        if #available(macOS 10.15, *) {
            monoFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        } else {
            monoFont = NSFont(name: "Menlo", size: 13) ?? NSFont.systemFont(ofSize: 13)
        }
        storage.addAttribute(.font, value: monoFont, range: fullRange)

        let nsText = text as NSString

        // swiftlint:disable force_try
        // Comments — green
        let commentRegex = try! NSRegularExpression(pattern: "#.*$", options: .anchorsMatchLines)
        for match in commentRegex.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor(red: 0.42, green: 0.68, blue: 0.40, alpha: 1.0), range: match.range)
        }

        // Keys (before colon) — cyan/blue
        let keyRegex = try! NSRegularExpression(pattern: "^(\\s*[\\w-]+)\\s*:", options: .anchorsMatchLines)
        for match in keyRegex.matches(in: text, range: fullRange) {
            let keyRange = match.range(at: 1)
            storage.addAttribute(.foregroundColor, value: NSColor(red: 0.40, green: 0.72, blue: 0.90, alpha: 1.0), range: keyRange)
        }

        // Strings — orange
        let stringRegex = try! NSRegularExpression(pattern: "([\"'])(?:(?=(\\\\?))\\2.)*?\\1", options: [])
        for match in stringRegex.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor(red: 0.90, green: 0.63, blue: 0.36, alpha: 1.0), range: match.range)
        }

        // Numbers — purple
        let numRegex = try! NSRegularExpression(pattern: "(?<=:\\s)\\d+\\.?\\d*(?=\\s*$)", options: .anchorsMatchLines)
        for match in numRegex.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor(red: 0.71, green: 0.51, blue: 0.90, alpha: 1.0), range: match.range)
        }

        // Booleans — magenta
        let boolRegex = try! NSRegularExpression(pattern: "(?<=:\\s)(true|false|yes|no)(?=\\s*$)", options: [.anchorsMatchLines, .caseInsensitive])
        for match in boolRegex.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor(red: 0.90, green: 0.42, blue: 0.68, alpha: 1.0), range: match.range)
        }

        // List markers — yellow
        let listRegex = try! NSRegularExpression(pattern: "^(\\s*)-\\s", options: .anchorsMatchLines)
        for match in listRegex.matches(in: text, range: fullRange) {
            let dashRange = NSRange(location: match.range.location + match.range(at: 1).length, length: 1)
            if dashRange.location + dashRange.length <= (text as NSString).length {
                storage.addAttribute(.foregroundColor, value: NSColor(red: 0.90, green: 0.86, blue: 0.45, alpha: 1.0), range: dashRange)
            }
        }

        // swiftlint:enable force_try
        storage.endEditing()
    }
}

// MARK: - NSTextViewDelegate

extension ConfigEditorWindowController: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performHighlight), object: nil)
        perform(#selector(performHighlight), with: nil, afterDelay: 0.3)
        statusLabel.stringValue = "Modified"
    }

    @objc private func performHighlight() {
        highlightYAML()
    }
}

// MARK: - Line Number Ruler

class LineNumberRulerView: NSRulerView {
    private weak var targetTextView: NSTextView?

    init(textView: NSTextView) {
        targetTextView = textView
        super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
        clientView = textView
        ruleThickness = 40

        NotificationCenter.default.addObserver(
            self, selector: #selector(textDidChange(_:)),
            name: NSText.didChangeNotification, object: textView
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(textDidChange(_:)),
            name: NSView.boundsDidChangeNotification,
            object: textView.enclosingScrollView?.contentView
        )
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    @objc func textDidChange(_ notification: Notification) {
        needsDisplay = true
    }

    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = targetTextView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else { return }

        let bgColor: NSColor
        if #available(macOS 10.14, *) {
            bgColor = NSColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1.0)
        } else {
            bgColor = .controlBackgroundColor
        }
        bgColor.setFill()
        rect.fill()

        let visibleRect = scrollView?.contentView.bounds ?? .zero
        let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        let visibleCharRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)

        let text = textView.string as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .regular),
            .foregroundColor: NSColor.secondaryLabelColor,
        ]

        var lineNumber = 1
        var index = 0
        while index <= visibleCharRange.location && index < text.length {
            let lineRange = text.lineRange(for: NSRange(location: index, length: 0))
            if index < visibleCharRange.location {
                lineNumber += 1
            }
            index = NSMaxRange(lineRange)
        }

        var glyphIndex = visibleGlyphRange.location
        while glyphIndex < NSMaxRange(visibleGlyphRange) {
            let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            let lineRange = text.lineRange(for: NSRange(location: charIndex, length: 0))
            var lineRect = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(forCharacterRange: lineRange, actualCharacterRange: nil), in: textContainer)
            lineRect.origin.y += textView.textContainerInset.height - visibleRect.origin.y

            let numStr = "\(lineNumber)" as NSString
            let strSize = numStr.size(withAttributes: attrs)
            let drawPoint = NSPoint(x: ruleThickness - strSize.width - 6, y: lineRect.origin.y + (lineRect.height - strSize.height) / 2)
            numStr.draw(at: drawPoint, withAttributes: attrs)

            lineNumber += 1
            glyphIndex = NSMaxRange(layoutManager.glyphRange(forCharacterRange: lineRange, actualCharacterRange: nil))
        }
    }
}
