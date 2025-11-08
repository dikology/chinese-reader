//
//  ReaderView.swift
//  ChineseReader
//
//  Reader view with word segmentation, pinyin, and dictionary lookup
//

import SwiftUI
import SwiftData

struct ReaderView: View {
    @Environment(\.modelContext) private var modelContext
    
    let text: CapturedText
    
    @State private var selectedWord: WordToken?
    @State private var showPinyin = false
    @State private var fontSize: CGFloat = 18

    private let segmentationService = TextSegmentationService()

    var words: [WordToken] {
        segmentationService.segmentText(text.content, language: text.language)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Reader content
                SegmentedTextView(
                    words: words,
                    showPinyin: showPinyin,
                    fontSize: fontSize,
                    onWordTap: { word in
                        selectedWord = word
                        //lookupWord(word.text)
                    }
                )
                .padding()
            }
        }
        .navigationTitle(text.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Menu("Font Size") {
                        Button("Small") { fontSize = 14 }
                        Button("Medium") { fontSize = 18 }
                        Button("Large") { fontSize = 22 }
                        Button("Extra Large") { fontSize = 26 }
                    }

                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

// Custom flow layout for text wrapping
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                x += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// View that displays segmented Chinese text with tap interactions
struct SegmentedTextView: View {
    let words: [WordToken]
    let showPinyin: Bool
    let fontSize: CGFloat
    let onWordTap: (WordToken) -> Void
    
    var body: some View {
        FlowLayout(spacing: 2) {
            ForEach(words) { word in
                if word.isWhitespace {
                    Text(word.text)
                        .font(.system(size: fontSize))
                } else {
                    WordButton(
                        text: word.text,
                        showPinyin: showPinyin,
                        fontSize: fontSize
                    ) {
                        onWordTap(word)
                    }
                }
            }
        }
    }
}

// Individual word button with optional pinyin
struct WordButton: View {
    let text: String
    let showPinyin: Bool
    let fontSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if showPinyin {
                VStack(spacing: 0) {
                    Text("pinyin") // TODO: Lookup actual pinyin
                        .font(.system(size: fontSize * 0.5))
                        .foregroundColor(.secondary)
                    Text(text)
                        .font(.system(size: fontSize))
                        .foregroundColor(.primary)
                }
            } else {
                Text(text)
                    .font(.system(size: fontSize))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let container = try! ModelContainer(for: CapturedText.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    let sampleText = CapturedText(
        content: "你好世界。这是一个测试。学习中文很有趣。",
        source: .camera,
        title: "Sample Text"
    )
    context.insert(sampleText)
    
    return NavigationStack {
        ReaderView(text: sampleText)
            .modelContainer(container)
    }
}

