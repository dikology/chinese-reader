# Contributing to Chinese Reader

Thank you for your interest in contributing to Chinese Reader! This document provides guidelines and instructions for contributing.

## 🌟 Ways to Contribute

- **Code**: Implement new features, fix bugs, improve performance
- **Documentation**: Improve README, add code comments, write tutorials
- **Design**: Create UI mockups, improve UX, design icons
- **Testing**: Report bugs, test on different devices, write unit tests
- **Translation**: Help translate the app to other languages
- **Community**: Answer questions, help other users, spread the word

## 🚀 Getting Started

### Setting Up Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork**:
```bash
git clone https://github.com/YOUR_USERNAME/chinese-reader.git
cd chinese-reader
```

3. **Add upstream remote**:
```bash
git remote add upstream https://github.com/dikology/chinese-reader.git
```

4. **Open in Xcode**:
```bash
open ChineseReader/ChineseReader.xcodeproj
```

5. **Build and run** (⌘R) to ensure everything works

### Keeping Your Fork Updated

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## 📋 Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding tests

### 2. Make Your Changes

- Write clean, documented code
- Follow Swift style guidelines
- Add comments for complex logic
- Keep commits focused and atomic

### 3. Test Your Changes

- Build and run on simulator
- Test on a real device if possible
- Verify all existing features still work
- Add unit tests for new functionality

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add your feature description"
```

Commit message format:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear title and description
- Reference any related issues
- Screenshots/videos for UI changes
- List of changes made

## 🎨 Code Style Guidelines

### Swift Style

Follow [Apple's Swift Style Guide](https://swift.org/documentation/api-design-guidelines/):

```swift
// Good
func processUserInput(_ text: String) -> Result<String, Error> {
    guard !text.isEmpty else {
        return .failure(ValidationError.emptyInput)
    }
    // ...
}

// Bad
func ProcessInput(text:String)->Result<String,Error>{
    if text.isEmpty{
        return .failure(ValidationError.emptyInput)
    }
}
```

### SwiftUI Best Practices

- Keep views small and focused
- Extract reusable components
- Use `@State`, `@Binding`, `@EnvironmentObject` appropriately
- Prefer `@Query` for SwiftData access

```swift
// Good - Small, focused view
struct BookRow: View {
    let book: Book
    
    var body: some View {
        HStack {
            BookCover(book: book)
            BookInfo(book: book)
        }
    }
}

// Bad - Monolithic view with too much logic
struct LibraryView: View {
    var body: some View {
        // 500 lines of complex UI and logic...
    }
}
```

### Comments and Documentation

```swift
/// Recognizes Chinese text from an image using Vision framework
/// 
/// - Parameters:
///   - image: The UIImage to process
///   - language: Language code (zh-Hans or zh-Hant)
/// - Returns: Recognized text as a String
/// - Throws: OCRError if recognition fails
func recognizeText(from image: UIImage, language: String) async throws -> String {
    // Implementation...
}
```

## 🧪 Testing

### Writing Tests

Place tests in `ChineseReaderTests/`:

```swift
import XCTest
@testable import ChineseReader

final class DictionaryServiceTests: XCTestCase {
    var service: DictionaryService!
    
    override func setUp() {
        super.setUp()
        service = DictionaryService()
    }
    
    func testLookupSimplifiedWord() async throws {
        try await service.loadDictionary()
        let entries = try await service.lookup(word: "你好")
        XCTAssertFalse(entries.isEmpty)
    }
}
```

### Running Tests

- Xcode: ⌘U
- Command line: `xcodebuild test`

## 🐛 Reporting Bugs

### Before Submitting

1. Check if the bug has already been reported
2. Try to reproduce on latest version
3. Test on a clean install if possible

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Tap on '...'
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Screenshots**
If applicable

**Environment**
- iOS version:
- Device:
- App version:
```

## 💡 Feature Requests

We love new ideas! When requesting a feature:

1. Check if it's already been requested
2. Explain the use case and benefits
3. Consider if it fits the app's philosophy
4. Be open to discussion and alternatives

### Feature Request Template

```markdown
**Problem**
What problem does this solve?

**Proposed Solution**
How should it work?

**Alternatives**
Other approaches considered?

**Additional Context**
Screenshots, mockups, examples
```

## 📝 Documentation

### What to Document

- New features and APIs
- Configuration options
- Complex algorithms
- Setup instructions
- Common issues and solutions

### Documentation Style

- Clear and concise
- Include code examples
- Add screenshots for UI features
- Keep up-to-date with code changes

## 🔍 Code Review Process

### For Contributors

- Be patient - reviews take time
- Respond to feedback constructively
- Make requested changes promptly
- Ask questions if unclear

### For Reviewers

- Be respectful and constructive
- Explain *why* changes are needed
- Suggest alternatives when possible
- Approve when requirements are met

## ⚖️ License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🎯 Priority Areas

Help is especially needed in these areas:

### High Priority
- [ ] YouTube subtitle extraction implementation
- [ ] Bilibili subtitle extraction
- [ ] Unit test coverage (target: 70%+)
- [ ] iPad optimization
- [ ] Learning groups with shared library

### Medium Priority
- [ ] Traditional Chinese support
- [ ] Offline dictionary improvements
- [ ] Performance optimization
- [ ] Accessibility features

### Nice to Have
- [ ] Study mode / spaced repetition
- [ ] Custom themes
- [ ] Widget support

## 🤔 Questions?

- Open a [GitHub Discussion](https://github.com/dikology/chinese-reader/discussions)
- Check existing [Issues](https://github.com/dikology/chinese-reader/issues)

## 🙏 Thank You!

Every contribution helps make Chinese Reader better for language learners worldwide. We appreciate your time and effort!

---

**Happy Coding! 加油！ 💪**

