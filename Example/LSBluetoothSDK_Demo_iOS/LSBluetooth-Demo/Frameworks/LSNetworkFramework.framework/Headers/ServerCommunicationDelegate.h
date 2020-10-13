//
//  ServerCommunicationDelegate.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseResponse.h"

typedef NSInteger RequestID;

@protocol ServerCommunicationDelegate <NSObject>
@required
- (void)onRequestSuccess:(LSBaseResponse*)response;
- (void)onRequestFail:(LSBaseResponse*)response;
@end
