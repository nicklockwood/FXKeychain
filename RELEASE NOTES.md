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