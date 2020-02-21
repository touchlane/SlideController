#!/usr/bin/env bash

# Formatting for the `Example` project
./Pods/SwiftFormat/CommandLineTool/swiftformat ./Example

# Formatting for the `SlideController` project
./Pods/SwiftFormat/CommandLineTool/swiftformat ./Source
./Pods/SwiftFormat/CommandLineTool/swiftformat ./Tests
