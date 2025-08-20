# Testing Guide

## Quick Start

### Run All Tests
```bash
bundle exec rails test:all
```

### Run System Tests (E2E) with Visible Browser
```bash
VISIBLE_TESTS=true bundle exec rails test:system
```

### Run Specific Test
```bash
bundle exec rails test test/system/crossword_functionality_test.rb
```

## What the Tests Cover

The system tests verify:
- Typing letters in crossword grid
- Navigation between cells
- Answer checking with visual feedback
- Grid clearing functionality
- Intersecting letter updates

## Test Data

Tests use a 5x5 puzzle with:
- **Across**: "HELLO" (A greeting)
- **Down**: "HAPPY" (Feeling good)

## GitHub Actions

Tests run automatically on push/PR to `main` or `develop` branches.

## Troubleshooting

### Database Issues
```bash
bundle exec rails db:test:prepare
```

### Chrome/ChromeDriver Mismatch
Download matching version from: https://chromedriver.chromium.org/
