//
//  LibraryView.swift
//  ChineseReader
//
//  Library view for managing saved texts and books
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \CapturedText.createdAt, order: .reverse)
    private var allTexts: [CapturedText]
    
    @Query(sort: \Book.updatedAt, order: .reverse)
    private var allBooks: [Book]
    
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingAddMenu = false
    
    var filteredTexts: [CapturedText] {
        if searchText.isEmpty {
            return allTexts
        }
        return allTexts.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("View", selection: $selectedTab) {
                    Text("Texts").tag(0)
                    Text("Books").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    textsListView
                } else {
                    booksListView
                }
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search library")
        }
    }
    
    private var textsListView: some View {
        Group {
            if filteredTexts.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(filteredTexts) { text in
                        NavigationLink(destination: ReaderView(text: text)) {
                            TextRowView(text: text)
                        }
                    }
                    .onDelete(perform: deleteTexts)
                }
            }
        }
    }
    
    private var booksListView: some View {
        Group {
            if allBooks.isEmpty {
                emptyBooksView
            } else {
                List {
                    ForEach(allBooks) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            BookRowView(book: book)
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Your library is empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Capture text with the camera or add content from videos")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    private var emptyBooksView: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No books yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Organize your texts into books for better learning")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    private func deleteTexts(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredTexts[index])
        }
    }
    
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(allBooks[index])
        }
    }
}

struct TextRowView: View {
    let text: CapturedText
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text.title)
                .font(.headline)
            
            Text(text.content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Image(systemName: sourceIcon)
                    .font(.caption)
                Text(text.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var sourceIcon: String {
        switch text.source {
        case .camera: return "camera"
        case .manual: return "doc.text"
        case .imported: return "square.and.arrow.down"
        }
    }
}

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        HStack {
            if let imageData = book.coverImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 70)
                    .cornerRadius(4)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 70)
                    .overlay(
                        Image(systemName: "book.closed")
                            .foregroundColor(.blue)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                
                if let author = book.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("\(book.pageCount) pages")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        List {
            Section {
                if let pages = book.pages {
                    ForEach(pages) { page in
                        NavigationLink(destination: ReaderView(text: page)) {
                            TextRowView(text: page)
                        }
                    }
                }
            } header: {
                Text("Pages")
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    LibraryView()
        .modelContainer(for: [CapturedText.self, Book.self], inMemory: true)
}

