# spm-ios-csr

This package has Swift API to generate CSR which uses ios-csr written in Objective-C. The ios-csr Objective-C is bridged to Swift to write this Swift API.

## Reference
This package refers  https://fivedottwelve.com/blog/installing-custom-rootca-certificates-programmatically-with-swift/ 
to implement this CSR generator Swift API but with a few changes as listed below:

## Improvements 
1. Importing this package, one can straightaway work in Swift,
2. SecExportKey API is OS X 10.7+ compatible where as SecKeyCopyExternalRepresentation is OS X 10.12+ compatible. Hence used SecExportKey
for people who need earlier OS X versions compatibility,
3. This package also always deletes any same public-private key pair in keychain before generating new ones with same application tag,


