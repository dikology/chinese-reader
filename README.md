# Chinese Reader

**A free, open-source iOS app for reading Chinese texts with OCR, dictionary lookup, and vocabulary management.**

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

### 📷 Camera OCR
- Capture Chinese text instantly with your camera
- Support for both Simplified and Traditional Chinese
- Built with Apple's Vision framework for accurate recognition

### 📚 Library Management
- Save captured texts to your personal library
- Organize texts into books/collections
- Search across all your content

### 📖 Smart Reading
- Automatic word segmentation using NLTokenizer
- Tap any word for instant dictionary lookup

## Coming Soon Features

### 📖 Smart Reading
- Mark vocabulary difficulty (easy/medium/hard)
- Pinyin display (optional)

### 🎥 Video Subtitle Extraction
- Extract Chinese subtitles from YouTube videos (with available transcripts)
- Bilibili support (if possible)
- Study content from your favorite videos

## 📖 Usage

### Capturing Text

1. Tap the **Camera** tab
2. Point your camera at Chinese text or select a photo from your library
3. Wait for OCR processing
4. Review and save the captured text

### Reading & Learning

1. Open any saved text from the **Library** tab
2. Tap any word to see dictionary definitions
3. Mark words by difficulty to build your vocabulary
4. Toggle pinyin display for pronunciation help

## 📝 Medium Priority Features

### UI Polish
- [ ] Loading states for async operations
- [ ] Better error messages and retry options
- [ ] Empty states with helpful guidance
- [ ] Dark mode testing and fixes
- [ ] Accessibility labels
- [ ] iPad layout optimization
- [ ] UI Kit (design system)

### Additional Unit Tests
**Target**: 70%+

Needed:
- [ ] OCRService tests (requires mocking)
- [ ] StorageService tests
- [ ] Model validation tests
- [ ] View model tests
- [ ] Integration tests

### Pinyin Integration
- [ ] Add pinyin lookup to DictionaryService
- [ ] Display pinyin above characters in ReaderView
- [ ] Cache pinyin for performance

## 📝 Low Priority Features

### App Store Assets
- [ ] Design app icon (1024x1024)
- [ ] Take screenshots (all device sizes)
- [ ] Write App Store description
- [ ] Create preview video (optional)
- [ ] Privacy policy page

### Advanced Features
- [ ] Shared library for small group study with or without teacher
- [ ] Local text level and proficincy level assessment
- [ ] YouTube and Bilibili subtitle extraction (for videos with available transcripts)
- [ ] Probably some backend for cloud sync and data storage, teacher's tools

## 🤝 Contributing

Contributions are welcome! This is an open-source project built for the Chinese learning community.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Write clean, documented Swift code
- Follow Apple's Swift style guide
- Add unit tests for new features
- Update documentation as needed
- Test on real devices when possible

### Good First Issues

Check out issues labeled `good first issue` for beginner-friendly contributions:
- [ ] Enhance UI/UX
- [ ] Write unit tests

## 📝 Roadmap

### Version 1.0 (MVP)
- [x] OCR text capture
- [x] Dictionary lookup (CC-CEDICT)
- [x] Text segmentation
- [ ] Library management

### Version 2.0
- [ ] Study groups
- [ ] Text level and proficiency level assessment
- [ ] Vocabulary tracking

### Version 3.0
- [ ] YouTube subtitle extraction
- [ ] Bilibili subtitle extraction

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- **CC-CEDICT** - Chinese-English dictionary data
- **Apple Vision Framework** - OCR capabilities
- **SwiftUI** - Modern iOS interface framework
- All open-source contributors!

## 📧 Contact

- GitHub Issues: [Report bugs or request features](https://github.com/dikology/chinese-reader/issues)
- Discussions: [Ask questions or share ideas](https://github.com/dikology/chinese-reader/discussions)

## ⭐ Star History

If you find Chinese Reader useful, please consider giving it a star! It helps others discover the project.

---

**Made with ❤️ for Chinese language learners**