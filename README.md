# Prebuilt Swift Collections

This is just a package that wraps the prebuilt Swift Collections library.

# How to use

Just launch the ./build.sh script, and this will generate a zipped xcframework inside the xcframework folder.

The zipped framework is included in the repo, and required as a binary target by the Package.swift file.

# Code signing

Before launching the script, it's important to update the CODESIGN_IDENTITY variable with the identity you want to use.

# How to update the swift-collections version

- In the build.sh script, change the TAG variable used to clone the repo
- Delete the local swift-collections folder, if you have one already
- Run the build.sh script
- Commit the new zipped xcframework and updated build.sh script