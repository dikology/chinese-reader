//
//  CameraView.swift
//  ChineseReader
//
//  Camera view for OCR text capture
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct CameraView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var recognizedText: String?
    @State private var isProcessing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingSaveSheet = false

    private let ocrService = OCRService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                if isProcessing {
                    ProgressView("Recognizing text...")
                        .padding()
                }
                
                if let text = recognizedText {
                    ScrollView {
                        Text(text)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .frame(maxHeight: 300)
                    
                    Button {
                        showingSaveSheet = true
                    } label: {
                        Label("Save to Library", systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                } else {
                    Text("Capture Chinese text with your camera or select a photo")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()

                HStack(spacing: 20) {
                    Button {
                        showingCamera = true
                    } label: {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                            Text("Camera")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Button {
                        showingImagePicker = true
                    } label: {
                        VStack {
                            Image(systemName: "photo.fill")
                                .font(.largeTitle)
                            Text("Photo Library")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Scan your text")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .sheet(isPresented: $showingSaveSheet) {
                if let text = recognizedText {
                    SaveTextSheet(text: text, image: selectedImage)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onChange(of: selectedImage) { _, newImage in
                if let image = newImage {
                    processImage(image)
                }
            }
        }
    }

    private func processImage(_ image: UIImage) {
        isProcessing = true
        recognizedText = nil
        
        Task {
            do {
                let text = try await ocrService.recognizeText(from: image, language: "zh-Hans")
                await MainActor.run {
                    recognizedText = text
                    isProcessing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isProcessing = false
                }
            }
        }
    }

}

// Image Picker wrapper for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// Sheet for saving captured text
struct SaveTextSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let text: String
    let image: UIImage?
    
    @State private var title = ""
    @State private var selectedBook: Book?
    @State private var showingNewBookAlert = false
    @State private var newBookTitle = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Text Title") {
                    TextField("Enter a title", text: $title)
                }
                
                Section("Preview") {
                    Text(text)
                        .font(.body)
                        .lineLimit(5)
                }
                
                Section("Organization") {
                    Button("Add to Book...") {
                        showingNewBookAlert = true
                    }
                    
                    if let book = selectedBook {
                        Text("Book: \(book.title)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Save Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveText()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert("New Book", isPresented: $showingNewBookAlert) {
                TextField("Book Title", text: $newBookTitle)
                Button("Cancel", role: .cancel) { }
                Button("Create") {
                    createNewBook()
                }
            }
        }
    }
    
    private func saveText() {
        let capturedText = CapturedText(
            content: text,
            source: .camera,
            title: title,
            book: selectedBook
        )
        
        modelContext.insert(capturedText)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving text: \(error)")
        }
    }
    
    private func createNewBook() {
        let book = Book(title: newBookTitle)
        modelContext.insert(book)
        selectedBook = book
        newBookTitle = ""
    }
}

#Preview {
    CameraView()
        .modelContainer(for: [CapturedText.self], inMemory: true)
}