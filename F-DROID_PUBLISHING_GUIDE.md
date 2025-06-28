# 📱 F-Droid Publishing Guide

## 🎯 Why F-Droid?

- **Completely FREE** - No registration fees
- **Open-source community** - Users who value privacy and freedom
- **Privacy-focused** - No tracking or ads
- **Global reach** - Available worldwide
- **Simple submission process**

## 📋 F-Droid Requirements

### ✅ Open Source Requirements
- [x] Source code must be publicly available
- [x] Use open-source licenses (GPL, MIT, Apache, etc.)
- [x] No proprietary dependencies
- [x] Build from source code

### ✅ Technical Requirements
- [x] APK must be built from source
- [x] No Google Play Services dependencies (if possible)
- [x] No proprietary libraries
- [x] Reproducible builds

## 🚀 Step-by-Step F-Droid Publishing Process

### Step 1: Prepare Your Repository

1. **Create a GitHub repository** (if you haven't already):
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/healthy_food_app.git
   git push -u origin main
   ```

2. **Add a LICENSE file** (choose one):
   - MIT License (recommended for beginners)
   - Apache 2.0 License
   - GPL v3 License

3. **Create a README.md** with:
   - App description
   - Features list
   - Installation instructions
   - Screenshots
   - License information

### Step 2: Create F-Droid Metadata

Create a file called `fdroid-metadata.yml` in your repository:

```yaml
Categories:
  - Health & Fitness
  - Food & Drink
License: MIT
WebSite: https://github.com/yourusername/healthy_food_app
SourceCode: https://github.com/yourusername/healthy_food_app
IssueTracker: https://github.com/yourusername/healthy_food_app/issues

Name: Healthy Food App
Summary: A comprehensive healthy food and meal planning app
Description: |
  Healthy Food App helps users discover nutritious recipes, track their meals, 
  and maintain a healthy lifestyle. Features include:
  
  • Meal discovery and recommendations
  • Nutritional tracking and analysis
  • Favorite recipes management
  • Shopping cart functionality
  • User authentication and profiles
  • Dark and light theme support
  • Local notifications for meal reminders
  • Offline recipe access
  
  The app is built with Flutter and uses Firebase for backend services.
  All user data is stored securely and privately.

RepoType: git
Repo: https://github.com/yourusername/healthy_food_app

Builds:
  - versionName: '1.0.0'
    versionCode: 1
    commit: v1.0.0
    subdir: app
    gradle:
      - yes
    output: app-release.apk
    srclibs:
      - flutter@3.8.1
    preassemble:
      - echo "flutter pub get"
      - flutter pub get
    assemble: flutter build apk --release
    ndk: r25c
    target: android-34

AutoName: Healthy Food App
```

### Step 3: Submit to F-Droid

1. **Fork the F-Droid data repository**:
   - Go to https://gitlab.com/fdroid/fdroiddata
   - Click "Fork" to create your own copy

2. **Add your app metadata**:
   - Clone your forked repository
   - Create a new file: `metadata/com.healthyfood.app.yml`
   - Copy the metadata from Step 2 above
   - Update the repository URLs with your actual GitHub username

3. **Create a merge request**:
   - Commit and push your changes
   - Create a merge request to the main F-Droid repository
   - Wait for review and approval

## 🔧 Build Configuration for F-Droid

### Update your `pubspec.yaml`:
```yaml
# Add these lines to your pubspec.yaml
repository: https://github.com/yourusername/healthy_food_app
homepage: https://github.com/yourusername/healthy_food_app
issue_tracker: https://github.com/yourusername/healthy_food_app/issues
```

### Create a LICENSE file (MIT License example):
```
MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 📝 Required Files for F-Droid

### 1. README.md
```markdown
# Healthy Food App

A comprehensive healthy food and meal planning app built with Flutter.

## Features

- 🍎 Meal discovery and recommendations
- 📊 Nutritional tracking and analysis
- ❤️ Favorite recipes management
- 🛒 Shopping cart functionality
- 👤 User authentication and profiles
- 🌙 Dark and light theme support
- 🔔 Local notifications for meal reminders
- 📱 Offline recipe access

## Screenshots

[Add screenshots of your app here]

## Installation

1. Download from F-Droid
2. Install the APK
3. Create an account or sign in
4. Start exploring healthy meals!

## Development

```bash
git clone https://github.com/yourusername/healthy_food_app.git
cd healthy_food_app
flutter pub get
flutter run
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### 2. Screenshots
- Take screenshots of your app's main features
- Save them in a `screenshots/` folder
- Include them in your README.md

## ⚠️ Important Notes for F-Droid

### Firebase Considerations
- F-Droid users are privacy-conscious
- Consider making Firebase optional or providing alternatives
- Document what data is collected and how it's used

### Dependencies
- Ensure all dependencies are open-source
- Document any proprietary services used
- Consider alternatives to Google services

### Build Process
- F-Droid builds your app from source
- Ensure your build process is reproducible
- Test the build process locally

## 🕐 Timeline

1. **Repository setup**: 1-2 hours
2. **Metadata creation**: 30 minutes
3. **F-Droid submission**: 15 minutes
4. **Review process**: 1-4 weeks
5. **Publication**: Automatic after approval

## 🆘 Common Issues

### Build Failures
- Ensure all dependencies are available
- Test build process locally
- Check for proprietary libraries

### Metadata Issues
- Follow F-Droid metadata format exactly
- Include all required fields
- Use correct repository URLs

### Review Process
- Be patient with the review process
- Respond to any feedback quickly
- Make requested changes promptly

## 📈 After Publication

1. **Monitor downloads** and user feedback
2. **Respond to issues** on your GitHub repository
3. **Plan regular updates** to keep users engaged
4. **Engage with the F-Droid community**

## 🎉 Success Tips

- **Quality over speed** - ensure your app works well
- **Documentation is key** - provide clear instructions
- **Be responsive** - answer questions and fix issues quickly
- **Regular updates** - keep your app current and secure

---

**Good luck with your F-Droid submission! 🚀** 