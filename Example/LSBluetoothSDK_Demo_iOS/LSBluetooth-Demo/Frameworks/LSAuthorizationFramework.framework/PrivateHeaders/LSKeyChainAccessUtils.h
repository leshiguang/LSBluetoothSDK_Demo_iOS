//
//  KeyChainAccessUtils.h
//  Pods
//
//  Created by alex.wu on 2020/4/2.
//
#import <Foundation/Foundation.h>

#ifndef KeyChainAccessUtils_h
#define KeyChainAccessUtils_h

#endif /* KeyChainAccessUtils_h */
#pragma mark - function by WangWang
#pragma mark - create uuid, 这个uuid就算删除了重新安装app也会保持同一个

 
static NSMutableDictionary *createKeychainQuery(NSString *service) {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

static void updateKeychain(NSString *service, id data) {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = createKeychainQuery(service);
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


static id getDataFromKeychain(NSString *service) {
    id ret = nil;
    NSMutableDictionary *keychainQuery = createKeychainQuery(service);
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
    CFRelease(keyData);
    return ret;
}
