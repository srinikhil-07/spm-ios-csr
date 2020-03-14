# spm-ios-csr

This package has Swift API to generate CSR which uses ios-csr written in Objective-C. The ios-csr Objective-C is bridged to Swift to write this Swift API.

## Based On
This repository is based on ios-csr repository written in Objective-C: https://github.com/ateska/ios-csr.git

## Reference
This package refers  https://fivedottwelve.com/blog/installing-custom-rootca-certificates-programmatically-with-swift/ 
to implement this CSR generator Swift API but with a few changes as listed below:

## Improvements 
1. Importing this package, one can straightaway work in Swift,
2. SecExportKey API is OS X 10.7+ compatible where as SecKeyCopyExternalRepresentation is OS X 10.12+ compatible. Hence used SecExportKey
for people who need earlier OS X versions compatibility,
3. This package also always deletes any same public-private key pair in keychain before generating new ones with same application tag,

## Usage
Add this swift package to your project. Import module 'swift_csr'. Then the API can be used like shown:

Initialize the class object,
let csrGenerator = GenerateCSR.init

Set the tags and labels for the keys,

Form a dictionary of options with keys: "commonName", "organizationName", "countryName" etc., and 
pass it as params to generateCSR(withOptins options:) API. 

The genrateCSR API does the following:
1. Generate RSA public-private key pair,
2. Deletes already existing key pair in keychain with supplied tag,label to avoid duplicates,
3. Uses ios-csr utility to generate CSR with the given key-pair.

The CSR thus formed can be sent to the server to request for a signed certificate.
