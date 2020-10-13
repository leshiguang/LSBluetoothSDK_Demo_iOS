//
//  HttpErrcode.h
//  LSWearable
//
//  Created by rolandxu on 15/12/27.
//  Copyright © 2015年 lifesense. All rights reserved.
//

#ifndef HttpErrcode_h
#define HttpErrcode_h

//HTTP 状态码表

//////正常字段
//消息
#define kHttpStatusCodeMsgStart (100)
#define kHttpStatusCodeMsgEnd (199)
//成功
#define kHttpStatusCodeSucceedStart (200)
#define kHttpStatusCodeSucceedOK (200)
#define kHttpStatusCodeSucceedEnd (299)
//重定向
#define kHttpStatusCodeRedirectStart (300)
#define kHttpStatusCodeRedirectFound (302)
#define kHttpStatusCodeRedirectSeeOther (303)
#define kHttpStatusCodeRedirectEnd (399)
//////异常字段
//请求错误
#define kHttpStatusCodeRequstErrorStart (400)
#define kHttpStatusCodeRequstErrorBadRequest (400)
#define kHttpStatusCodeRequstErrorForbidden (403)
#define kHttpStatusCodeRequstErrorNotFound (404)
#define kHttpStatusCodeRequstErrorRequestTimeout (408)
#define kHttpStatusCodeRequstErrorEnd (499)
//服务器错误
#define kHttpStatusCodeServerErrorStart (500)
#define kHttpStatusCodeServerErrorBadGateway (502)
#define kHttpStatusCodeServerErrorGatewayTimeout (504)
#define kHttpStatusCodeServerErrorEnd (599)


#endif /* HttpErrcode_h */
