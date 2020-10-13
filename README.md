# LSBluetoothSDK_Demo_iOS

[![CI Status](https://img.shields.io/travis/alex.wu/LSBluetoothSDK_Demo_iOS.svg?style=flat)](https://travis-ci.org/alex.wu/LSBluetoothSDK_Demo_iOS)
[![Version](https://img.shields.io/cocoapods/v/LSBluetoothSDK_Demo_iOS.svg?style=flat)](https://cocoapods.org/pods/LSBluetoothSDK_Demo_iOS)
[![License](https://img.shields.io/cocoapods/l/LSBluetoothSDK_Demo_iOS.svg?style=flat)](https://cocoapods.org/pods/LSBluetoothSDK_Demo_iOS)
[![Platform](https://img.shields.io/cocoapods/p/LSBluetoothSDK_Demo_iOS.svg?style=flat)](https://cocoapods.org/pods/LSBluetoothSDK_Demo_iOS)

## Example


## introduction

[ios api documents](https://docs.leshiguang.com/#/develop-native/ios/bluetooth  "ios api documents")

------
### 1、Search bluetooth device

    -(BOOL)searchDevice:(NSArray *)deviceTypes
          broadcast:(BroadcastType)broadcastType
       resultsBlock:(SearchResultsBlock)searchResults;

### 2、Pair device

    -(BOOL)pairingWithDevice:(LSDeviceInfo *)lsDevice
                delegate:(id<LSDevicePairingDelegate>)pairedDelegate;

### 3、Add Paired Device to measure device list

    -(BOOL)addMeasureDevice:(LSDeviceInfo *)lsDevice result:(void (^)(LSAccessCode)) result;
### 4、Start sync data

    -(BOOL)startDataReceiveService:(id<LSDeviceDataDelegate>)dataDelegate;


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation



## Author

alex.wu, yong.wu@lifesense.com

## License

LSBluetoothSDK_Demo_iOS is available under the MIT license. See the LICENSE file for more info.
