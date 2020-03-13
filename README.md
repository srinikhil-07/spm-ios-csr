# spm-ios-csr

This is a very simple Swift package based on ios-csr. This package wraps ios-csr which is in Objective-C into Swift.
This package refers  https://fivedottwelve.com/blog/installing-custom-rootca-certificates-programmatically-with-swift/ 
to write this Swift wrapper with a few changes

This package has a few changes:
1. Importing this package, one can straightaway work in Swift,
2. SecExportKey API is OS X 10.7+ compatible where as SecKeyCopyExternalRepresentation is OS X 10.12+ compatible. Hence used SecExportKey
for people who need earlier OS X versions compatibility,
3. This package also always deletes any same public-private key pair in keychain before generating new ones with same application tag,

TO.DO:
1. Licensing,
2. Multiple Apple Platform support,

