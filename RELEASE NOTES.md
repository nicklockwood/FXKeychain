Version 1.3.4

- Fixed bug where passwords containing certain special characters could be wrongly interpreted as a property list when loading
- Added code to prevent injection attacks based on users supplying a password containing binary plist data

Version 1.3.3

- Fixed issue with deleting keychain items on Mac OS

Version 1.3.2

- Now throws an exception if you try to encode an invalid object type instead of merely logging to console

Version 1.3.1

- Fixed singleton implementation

Version 1.3

- Removed ability to store arbitrary classes in keychain for security reasons (see README). It is still possible to store dictionaries, arrays, etc.

Version 1.2

- It is now possible to actually store more than one value per FXKeychain
- Removed account parameter (it didn't work the way I thought)

Version 1.1

- Now uses application bundle ID to namespace the default keychain
- Now supports keyed subcripting (e.g. keychain["foo"] = bar;)
- Included CocoaPods podspec file
- Incuded Mac example

Version 1.0

- Initial release