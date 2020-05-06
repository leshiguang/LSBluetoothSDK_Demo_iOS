//
//  LSJSonResponse.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "LSBaseResponse.h"

#define PROTOCOL_JSON_KEY_RET @"code"
#define PROTOCOL_JSON_KEY_MSG @"msg"
#define PROTOCOL_JSON_KEY_DATA @"data"
#define PROTOCOL_JSON_KEY_ERRCODE @"code"

@interface LSJSonResponse : LSBaseResponse
{
    NSDictionary* _datadict;
}
@property (nonatomic,retain) NSDictionary* datadict;
@end
