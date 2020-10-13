//
//  LSBluetoothManagerProfiles.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/14.
//  Copyright © 2017年 sky. All rights reserved.
//

#ifndef LSBluetoothManagerProfiles_h
#define LSBluetoothManagerProfiles_h

@class LSDeviceInfo;

/**
 * 扫描结果回调代码块
 */
typedef void(^SearchResultsBlock)(LSDeviceInfo *lsDevice);

/**
 * push指令设置结果回调代码块
 */
typedef void(^DeviceSettingBlock)(BOOL isSuccess,NSUInteger errorCode);


//配置设备wifi password的代码块
typedef void(^ConfigWifiPasswordBlock)(BOOL isSuccess,NSInteger errorCode);


/**
 * 管理器当前的工作状态
 */
typedef NS_ENUM(NSUInteger,LSBManagerStatus)
{
    ManagerStatusFree=0,       //空闲
    ManagerStatusScaning=1,    //扫描状态
    ManagerStatusPairing=2,    //设备配对状态
    ManagerStatusSyncing=3,    //设备同步状态
    ManagerStatusUpgrading=4,  //设备升级状态
};

/**
 * 扫描模式
 */
typedef NS_ENUM(NSUInteger,BluetoothScanMode)
{
    ScanModeFree=0,     //空闲
    ScanModeNormal=1,   //正常的扫描模式
    ScanModeUpgrade=2,  //升级模式下的扫描
    ScanModelSync=3,    //数据同步模式下的扫描
};

/**
 * 设备工作状态
 */
typedef NS_ENUM(NSUInteger,LSDeviceWorkingStatus)
{
    LSDeviceWorkingStatusFree=0,            //空闲状态
    LSDeviceWorkingStatusPairing=1,         //配对设备状态
    LSDeviceWorkingStatusSyncData=2,        //数据同步状态
    LSDeviceWorkingStatusUpgrading=3,       //设备升级状态
    LSDeviceWorkingStatusReadDeviceInfo=4,  //读取设备信息模式
    LSDeviceWorkingStatusEnterUpgradeMode=5,//进入升级模式
    LSDeviceWorkingStatusConfigWifiPassword=6,//配置设备wifi密码
};

/**
 * 设备断开状态
 */
typedef NS_ENUM(NSUInteger,LSDisconnectStatus)
{
    LSDisconnectStatusUnknown=0,    //未知状态
    LSDisconnectStatusAbnormal,     //异常断开，因连接状态改变而触发的断开
    LSDisconnectStatusCancel,       //SDK内部因异常情况而调用的断开
    LSDisconnectStatusRequest,      //请求断开，触发条件是外界调用接口
    LSDisconnectStatusClose,        //释放蓝牙资源，关闭gatt连接
};

/**
 * 设备设置信息类型
 */
typedef NS_ENUM(NSUInteger,LSDeviceSettingType)
{
    STProductUserInfo=0x01,
    STPedometerUserInfo=0x02,
    STPedometerAlarmClock=0x03,
};

/**
 * 协议版本
 */
typedef NS_ENUM(NSUInteger, LSProtocolVer)
{
    LSProtocolVerA2 = 1,
    LSProtocolVerA3,
    LSProtocolVerA3_1,
    LSProtocolVerA4,
    LSProtocolVerA5_80,
    LSProtocolVerA5_AA,
    LSProtocolVerA6_Scale
};

typedef NS_ENUM(NSUInteger, LSPlatform)
{
    LSPlatformUnknown,
    LSPlatformIOS,
    LSPlatformAndroid,
    LSPlatformWP
};

#pragma mark - Interface defines constants

/**
 * 设备类型
 */
typedef NS_ENUM(NSUInteger,LSDeviceType)
{
    LSDeviceTypeUnknown=0,              //设备类型未知
    LSDeviceTypeWeightScale=1,          //01 体重秤
    LSDeviceTypeFatScale = 2,           //02 脂肪秤
    LSDeviceTypeHeightMeter = 3,        //03 身高测量仪
    LSDeviceTypePedometer =4,           //04 手环
    LSDeviceTypeWaistlineMeter=5,       //05 腰围尺
    LSDeviceTypeBloodGlucoseMeter=6,    //06 血糖仪
    LSDeviceTypeThermometer=7,          //07 温度计
    LSDeviceTypeBloodPressureMeter =8,  //08 血压计
    LSDeviceTypeKitchenScale = 9,       //09 厨房秤
};


/**
 * 设备广播类型
 */
typedef NS_ENUM(NSUInteger,BroadcastType)
{
    BroadcastTypeNormal=1,      //设备的正常广播
    BroadcastTypePair=2,        //设备配对广播
    BroadcastTypeAll=3,         //设备的所有广播
};

/**
 * 设备的连接状态
 */
typedef NS_ENUM(NSUInteger,LSDeviceConnectState)
{
    LSDeviceStateUnknown=0,             //未知
    LSDeviceStateConnected=1,           //底层连接成功
    LSDeviceStateConnectFailure=2,      //连接失败
    LSDeviceStateDisconnect=3,          //连接断开
    LSDeviceStateConnecting=4,          //连接中
    LSDeviceStateConnectionTimedout=5,  //连接超时
    LSDeviceStateConnectSuccess=6,      //协议层的连接成功
} ;


/**
 * 测量单位
 */
typedef NS_ENUM(NSUInteger,LSMeasurementUnit)
{
    LSMeasurementUnitKg=0,      //kg
    LSMeasurementUnitLb=1,      //磅
    LSMeasurementUnitSt=2,      //英石
    LSMeasurementUnitJin=3,     //斤
};


/**
 * 性别类型，1表示男，2表示女
 */
typedef NS_ENUM(NSUInteger,LSUserGender)
{
    LSUserGenderMale=1,
    LSUserGenderFemale=2
};


/**
 * 设备配对结果
 */
typedef NS_ENUM(NSUInteger,LSDevicePairedResults)
{
    LSDevicePairedResultsUnknown=0, //未知
    LSDevicePairedResultsSuccess=1, //配对成功
    LSDevicePairedResultsFailed=2,  //配对失败
};



/**
 * 设备升级状态
 */
typedef NS_ENUM(NSUInteger,LSDeviceUpgradeStatus)
{
    LSUpgradeStatusUnknown=0,                   //未知状态
    LSUpgradeStatusSearch=1,                    //扫描正常模式下的设备广播
    LSUpgradeStatusSearchUpgradingDevice=2,     //扫描升级模式下的设备广播
    LSUpgradeStatusConnect=3,                   //连接正常模式下的设备
    LSUpgradeStatusConnectUpgradingDevice=4,    //连接升级模式下的设备
    LSUpgradeStatusEnterUpgradeMode=5,          //进入升级模式
    LSUpgradeStatusUpgrading=6,                 //正在升级
    LSUpgradeStatusUpgradeSuccess=7,            //升级成功
    LSUpgradeStatusUpgradeFailure=8,            //升级失败
    LSUpgradeStatusResetting=9,                 //设备重启中
};


/**
 * 设备绑定方式
 */
typedef NS_ENUM(NSUInteger,LSDevicePairingMode)
{
    LSPairingModeRandomNumber=0x01,     //随机码绑定
};

/**
 * 震动方式
 */
typedef NS_ENUM(NSUInteger, LSVibrationMode)
{
    LSVibrationModeContinued,       //持续震动
    LSVibrationModeInterval,        //间歇震动，震动强度不变
    LSVibrationModeIntervalS2L,     //间歇震动，震动强度由小变大
    LSVibrationModeIntervalL2S,     //间歇震动，震动强度由大变小
    LSVibrationModeIntervalLoop,    //间歇震动，震动强度大小循环
};

/**
 * 星期类型
 */
typedef NS_ENUM(NSUInteger, LSWeek)
{
    LSWeekNone,
    LSWeekMonday = 1,       //星期一
    LSWeekTuesday,          //星期二
    LSWeekWednesday,        //星期三
    LSWeekThursday,         //星期四
    LSWeekFriday,           //星期五
    LSWeekSaturday,         //星期六
    LSWeekSunday,           //星期天
};

/**
 * 消息设置类型
 */
typedef NS_ENUM(NSUInteger,LSDeviceMessageType)
{
   LSDeviceMessageAll=0x00,        //所有消息
   LSDeviceMessageIncomingCall=1,  //来电消息
   LSDeviceMessageDefault=2,       //消息提醒
   LSDeviceMessageDisconnect=3,    //连接断开消息
   LSDeviceMessageSMS=4,           //短信消息
   LSDeviceMessageWechat=5,        //微信消息
   LSDeviceMessageQQ=6,            //QQ消息
   LSDeviceMessageFacebook=0x07,   //Facebook 提醒
   LSDeviceMessageTwitter=0x08,    //Twitter 提醒
   LSDeviceMessageLine=0x09,       //Line 提醒
   LSDeviceMessageGmail=0x0A,      //Gmail 提醒
   LSDeviceMessageKakaoTalk=0x0B,  //Kakao Talk 提醒
   LSDeviceMessageWhatsApp=0x0C,   //Whats App 提醒
   LSDeviceMessageSEWellness=0xFE, //SE Wellness 提醒
   LSDeviceMessageCustom=0xFF,    //自定义消息

};



/**
 * 步频信息
 */
typedef NS_ENUM(NSUInteger, LSStepFreqStatus)
{
    LSStepFreqStatusRunStart,   //跑步开始
    LSStepFreqStatusRunOver,    //跑步结束
    LSStepFreqStatusRunPause,   //跑步暂停
    LSStepFreqStatusRunReStart  //跑步重新开始
};

/**
 * 每周目标
 */
typedef NS_ENUM(NSUInteger, LSWeekTarget)
{
    LSWeekTargetStep,           //每周的目标步数
    LSWeekTargetCalories,       //每周的目标卡路里
    LSWeekTargetDistance,       //每周的目标距离
    LSWeekTargetExerciseAmount  //每周的目标运动量
};

/**
 * 手环佩戴方式
 */
typedef NS_ENUM(NSInteger,LSWearingStyle)
{
    LSWearingStyleLeftHand,     //左手佩戴
    LSWearingStyleRightHand     //右手佩戴
};

/**
 * 屏幕显示
 */
typedef NS_ENUM(NSInteger,LSScreenDisplayMode)
{
    LSScreenDisplayModeHorizontal,  //横屏
    LSScreenDisplayModeVertical     //竖屏
};


/**
 * 手环页面
 */
typedef NS_ENUM(NSInteger,LSDevicePageType)
{
    LSDevicePageTime,       //时间
    LSDevicePageStep,       //步数
    LSDevicePageCalories,   //卡路里
    LSDevicePageDistance,   //距离
    LSDevicePageHeartRate,  //心率
    LSDevicePageRunning,    //跑步
    
    LSDevicePageWalking,    //健走
    LSDevicePageCycling,    //骑行
    LSDevicePageSwimming,   //游泳
    LSDevicePageBodyBuilding,//健身/力量训练
    LSDevicePageClimbing,   //登山
    LSDevicePageDailyData,  //日常数据
    LSDevicePageStopwatch,  //秒表
    LSDevicePageWeather,    //天气
    LSDevicePageBattery,    //电量
    

    LSDevicePageIndoorRunning=0x0F,     //跑步机运动
    LSDevicePageElliptical=0x10,        //椭圆机
    LSDevicePageAerobicSport=0x11,      //有氧运动
    LSDevicePageBasketball=0x12,        //篮球
    LSDevicePageFootball=0x13,          //足球
    LSDevicePageBadminton=0x14,         //羽毛球
    LSDevicePageVolleyball=0x15,        //排球
    LSDevicePagePingPong=0x16,          //乒乓球
    LSDevicePageYoga=0x17,              //瑜伽
    LSDevicePageGaming=0x18,            //电竞
    LSDevicePageAerobicExercise12=0x19, //有氧能力运动-12分钟跑
    LSDevicePageAerobicExercise6=0x1A,  //有氧能力运动-6分钟走
    LSDevicePageAlipay=0x1B,            //支付宝页面
    LSDevicePageFitnessDance=0x1C,      //健身舞
    LSDevicePageTaiChi=0x1D,            //太极
    
    LSDevicePageHealthScore=0x40,       //健康分数界面
    LSDevicePageMusicPlayer=0x41,       //音乐控制界面
    LSDevicePagePhoneLocation=0x42,     //寻找手机界面
    LSDevicePageDeviceSetting=0x43,     //设置手环界面
    LSDevicePageAgenda=0x44,            //Kchiing Agenda
    LSDevicePageReminderQuery=0x45,     //Kchiing Reminder Query
};

/**
 * 手环心率检测方式
 */
typedef NS_ENUM(NSInteger ,LSHRDetectionMode)
{
    LSHRDetectionModeTurnOff,       //关闭心率检测
    LSHRDetectionModeTurnOn,        //开启心率检测
    LSHRDetectionModeIntelligent    //开启智能心率检测
};

/**
 * 手环发送运动模式类型
 */
typedef NS_ENUM(NSUInteger,LSDeviceSportMode)
{
    LSSportModeRunning = 1,             //运动模式 - 跑步
    LSSportModeWalking = 2,             //运动模式 - 健走
    LSSportModeCycling = 3,             //运动模式 - 骑行
    LSSportModeSwimming = 4,            //运动模式 - 游泳
    LSSportModeBodyBuilding = 5,        //运动模式 - 健身/力量训练
    LSSportModeNewRunning = 6,          //运动模式 - 新跑步模式
    LSSportModeIndoorRunning=7,         //运动模式 - 跑步机运动
    LSSportModeElliptical=8,            //运动模式 - 椭圆机运动
    LSSportModeAerobicSport=9,          //运动模式 - 有氧运动
    LSSportModeBasketball=0x0A,         //运动模式 - 篮球运动
    LSSportModeFootball=0x0B,           //运动模式 - 足球运动
    LSSportModeBadminton=0x0C,          //运动模式 - 羽毛球运动
    LSSportModeVolleyball=0x0D,         //运动模式 - 排球运动
    LSSportModePingpong=0x0E,           //运动模式 - 乒乓球运动
    LSSportModeYoga=0x0F,               //运动模式 - 瑜伽运动
    LSSportModeGaming=0x10,             //运动模式 - 电竞运动
    LSSportModeAerobicSport12=0x11,     //运动模式 -有氧运动 12分钟跑
    LSSportModeAerobicSport6=0x12,      //运动模式 -有氧运动 6分钟走
    LSSportModeFitnessDance=0x13,       //运动模式 - 健身舞
    LSSportModeTaiChi=0x14,             //运动模式 - 太极

};

/**
 * 手环发送运动子模式类型
 */
typedef NS_ENUM(NSUInteger,LSDeviceSportSubMode)
{
    LSRunningModeWithWatch =0,             //mambo watch跑步模式
    LSRunningModeWithAutoRecognition=1,   //自动识别跑步模式
    LSRunningModeWithGPS=2,               //连接GPS的跑步模式
    LSRunningModeWithoutGPS=3             //没有连接GPS的跑步模式
};

/**
 * 手环发送运动状态通知
 */
typedef NS_ENUM(NSUInteger,LSSportNotifyType)
{
    LSSportNotifyTypeUnknown=0,      //未知类型
    LSSportNotifyTypeGps = 1,        //GPS状态检测通知
    LSSportNotifyTypeSportState=2,   //运动状态通知
};

/**
 * 手环距离单位类型
 */
typedef NS_ENUM(NSInteger,LSDistanceUnit)
{
    LSDistanceUnitMetricSystem,     //公制
    LSDistanceUnitBritishSystem,    //英制
};

/**
 * 手环时间显示类型（时制）
 */
typedef NS_ENUM(NSInteger,LSDeviceTimeFormat)
{
    LSDeviceTimeFormat24,    //24小时制
    LSDeviceTimeFormat12     //12小时
};


#pragma mark - Get Setting Info from Device

/**
 * 获取设备信息类型
 */
typedef NS_ENUM(NSUInteger, LSGetDeviceInfoType)
{
    LSGetDeviceInfoTypeReadFlashInfo,       //读取flash信息
    LSGetDeviceInfoTypeReadUserInfo,        //用户信息
    LSGetDeviceInfoTypeReadAlarmClockInfo,  //闹钟设置信息
    LSGetDeviceInfoTypeReadCallReminderInfo,//来电提醒设置信息
    LSGetDeviceInfoTypeReadCheckHRInfo,     //心率检测设置信息
    LSGetDeviceInfoTypeReadSedentaryInfo,   //久不动提醒设置信息
    LSGetDeviceInfoTypeReadProtectLostInfo  //防丢设置信息
};


#pragma mark - ErrorCode

/**
 * 错误码
 */
typedef NS_ENUM(NSUInteger,LSErrorCode)
{
    ECodeUnknown=0,
    ECodeParameterInvalid=1,                //接口参数错误
    ECodeUpgradeFileFormatInvalid=2,        //升级文件的格式错误
    ECodeUpgradeFileNameInvalid=3,          //文件名错误
    ECodeWorkingStatusError=5,              //蓝牙SDK工作状态错误
    ECodeDeviceNotConnected=7,              //设备未连接
    ECodeDeviceUnsupported=8,               //当前push信息的类型与设备实际支持的功能不相符
    ECodeUpgradeFileVerifyError=9,          //校验文件出错
    ECodeUpgradeFileDataReceiveError=10,    //数据接收失败
    ECodeLowBattery=11,                     //电量不足
    ECodeCodeVersionInvalid=12,             //代码版本不符合，拒绝升级固件文件
    ECodeUpgradeFileHeaderVerifyError=13,   //固件文件头信息校验失败，拒绝升级固件文件
    ECodeFlashSaveError=14,                 //设备保存数据出错,flash保存失败
    ECodeScanTimeout=15,                    //扫描超时，找不到目标设备
    ECodeConnectionFailed=17,               //连接失败，3次重连连接不上，则返回连接失败
    ECodeConnectionTimeout=21,              //连接错误，若120秒内，出现连接无响应、或发现服务无响应
    ECodeBluetoothUnavailable=23,           // 蓝牙关闭
    ECodeAbnormalDisconnect=24,             //异常断开
    ECodeWriteCharacterFailed=25,           //写特征错误
    ECodeCancelUpgrade=26,                  //主动取消升级
    ECodeDeviceConfigWifiPasswordFailed=27, //设备配置wifi密码失败
    
#pragma mark - Version 1.1.0 Update
    
    ECodeRandomCodeVerifyFailure=28,        //随机码验证错误
    ECodeWriteRandomCodeFailure=29,         //写随机码失败
    ECodeWritePairedConfirmFailure=30,      //写配对确认失败
    ECodeWriteDeviceIdFailure=31,           //写设备ID失败
};

#pragma mark - new change for v1.0.5

/**
 * 手环表盘样式
 */
typedef NS_ENUM(NSUInteger,LSDialPeaceStyle)
{
    LSDialPeaceStyle1 = 1,  //表盘1
    LSDialPeaceStyle2 = 2,  //表盘2
    LSDialPeaceStyle3 = 3,  //表盘3
    LSDialPeaceStyle4 = 4,  //表盘4
    LSDialPeaceStyle5 = 5,  //表盘5
    LSDialPeaceStyle6 = 6,  //表盘6
    LSDialPeaceStyle7 = 7,  //表盘7
    LSDialPeaceStyle8 = 8,  //表盘8
    LSDialPeaceStyle9 = 9,  //表盘9
    LSDialPeaceStyle10 =10, //表盘10
};

/**
 * 运动模式自动识别
 */
typedef NS_ENUM(NSUInteger,LSAutomaticSportstype)
{
    LSAutomaticSportstypeWalking = 1,   //健走
    LSAutomaticSportstypeRunning = 2,   //跑步
    LSAutomaticSportstypeCycling = 3,   //骑行
};

/**
 * 鼓励目标类型
 */
typedef NS_ENUM(NSUInteger,LSEncourageTargetType)
{
    LSEncourageTargetTypeStepNum = 1,   //目标步数
    LSEncourageTargetTypeCalories = 2,  //目标卡路里
    LSEncourageTargetTypeDistance = 3,  //目标距离
};

/**
 * 天气类型
 */
typedef NS_ENUM(NSUInteger,LSWeatherType)
{
    LSWeatherTypeSunnyDuring = 0,       //晴(白天)
    LSWeatherTypeSunnyNight,            //晴(晚上)
    LSWeatherTypeCloudy,                //多云
    LSWeatherTypeSunnyAndCloudyDuring,  //晴间多云(白天)
    LSWeatherTypeSunnyAndCloudyNight,   //晴间多云(夜晚)
    LSWeatherTypeMostCloudyDuring,      //大部多云（白天）
    LSWeatherTypeMostCloudyNight,       //大部多云（夜晚）
    LSWeatherTypeGloomy,                //阴天
    LSWeatherTypeShower,                //阵雨
    LSWeatherTypeThunderyShower,        //雷阵雨
    LSWeatherTypeHail,                  //冰雹或雷阵雨伴有冰雹
    LSWeatherTypedRizzle,               //小雨
    LSWeatherTypedModerateRain,         //中雨
    LSWeatherTypedDownpour,             //大雨
    LSWeatherTypedHeavyRains,           //暴雨
    LSWeatherTypedBigHeavyRains,        //大暴雨
    LSWeatherTypedRainstorm,            //特大暴雨
    LSWeatherTypedFreezingRain,         //冻雨
    LSWeatherTypedSleet,                //雨夹雪
    LSWeatherTypedSnowShower,           //阵雪
    LSWeatherTypedLightSnow,            //小雪
    LSWeatherTypedModerateSnow,         //中雪
    LSWeatherTypedBigSnow,              //大雪
    LSWeatherTypedBlizzard,             //暴雪
    LSWeatherTypedFlyAsh,               //浮尘
    LSWeatherTypedDust,                 //扬尘
    LSWeatherTypedStorms,               //沙尘暴
    LSWeatherTypedStrongStorms,         //强沙尘暴
    LSWeatherTypedFog,                  //雾
    LSWeatherTypedHaze,                 //霾
    LSWeatherTypedWind,                 //风
    LSWeatherTypedBigWind,              //大风
    LSWeatherTypedHurricane,            //飓风
    LSWeatherTypedTropicalStorm,        //热带风暴
    LSWeatherTypedTornado,              //龙卷风
};


#pragma mark - LSPacket Type

/**
 * 设备的数据包命令字
 */
typedef NS_ENUM(NSUInteger,LSPacketProfile)
{
    /**
     * 无法解析的异常数据包
     */
    LSPacketException=0xFF,
    /**
     * 未知的数据包
     */
    LSPacketUnknown=0X00,
    /**
     * 测量数据包回复命令字
     */
    LSPacketDataResponse=0X01,
    /**
     * 来电信息数据包命令字
     */
    LSPacketPushCallMessage=0X02,
    /**
     * 消息提醒数据包命令字
     */
    LSPacketPushAncsMessage=0X03,
    
    /**
     * 用户信息设置命令字
     */
    LSPacketPushUserInfo=0X68,
    /**
     * 手环闹钟设置命令字
     */
    LSPacketPushAlarmClock=0X69,
    /**
     * 手环来电提醒设置命令字
     */
    LSPacketPushCallRemindMessage=0X6A,
    /**
     * 手环心率检测设置命令字
     */
    LSPacketPushHeartRateDetection=0x6D,
    /**
     * 手环久坐提醒设置命令字
     */
    LSPacketPushSedentary=0X6E,
    /**
     * 手环防丢设置命令字
     */
    LSPacketPushAnitlost=0X6F,
    /**
     * 手环心率模式设置命令字
     */
    LSPacketPushHeartRateDetectionMode=0x76,
    /**
     * 手环夜间模式设置命令字
     */
    LSPacketPushNightMode=0X77,
    /**
     * 手环佩戴方式设置命令字
     */
    LSPacketPushWearingStyles=0X7A,
    /**
     * 手环屏幕显示模式设置命令字
     */
    LSPacketPushScreenMode=0X7D,
    /**
     * 手环自定页面显示设置命令字
     */
    LSPacketPushCustomPageStyles=0X7E,
    
    /**
     * 设置表盘的样式
     */
    LSPacketPushDialStyles=0xA1,
    /**
     * 设置自动识别的开关
     */
    LSPacketPushAutoRecognition=0xA2,
    /**
     * 设置事件提醒
     */
    LSPacketPushEventReminder=0xA3,
    /**
     * 设置不同类型的鼓励
     */
    LSPacketPushEncourageInfo=0xA5,
    /**
     * 设置天气的相关信息
     */
    LSPacketPushWeatherInfo=0xA6,
    
    /**
     * A5协议手环步数目标设置的命令字
     */
    LSPacketPushTargetSteps=0X70,
    
    /**
     * A5协议手环心率区间设置的命令字
     */
    LSPacketPushHeartRateRange=0X71,
    
    /**
     * 通过用户年龄计算心率区间，push 心率区间到手环
     */
    LSPacketPushHeartRateRangeFromAge=0X74,
    /**
     * 查询设备配置信息
     */
    LSPacketQueryDeviceConfigInfo=0X66,
    
    /**
     * 手环距离单位
     */
    LSPacketPushDistanceUnit=0x78,
    
    /**
     * 手环时间显示格式
     */
    LSPacketPushTimeFormat=0x79,
        
    /**
     * 设置运动模式下的心率预警信息
     */
    LSPacketPushHeartRateAlert=0xA8,
    
    /**
     * 设置重置设备工作状态指令，如重新登录、通知设备断开连接
     */
    LSPacketPushResetDeviceState=0xA9,
    
    /**
     * 设置在GPS状态下的运动配速、距离等参数设置
     */
    LSPacketPushSportInfo=0xAB,
    
    
    /**********************************************/
    
    /**
     * 旧微信协议手环，设备信息数据包命令字
     * 类型:Mambo
     */
    LSPacketCommand0A=0x0A,
    
    LSPacketCommandC7=0XC7,
    /**
     * 旧微信协议手环，手环每天步数测量数据包命令字
     */
    LSPacketCommandCA=0XCA,
    /**
     * 旧微信协议手环，手环每小时步数测量数据包命令字
     */
    LSPacketCommandC9=0XC9,
    /**
     * 旧微信协议手环，手环睡眠测量数据包命令字
     */
    LSPacketCommandCE=0XCE,
    /**
     * 微信秤，设备信息数据包命令字
     */
    LSPacketCommandCC=0XCC,
    /**
     * 微信秤，体重测量数据包命令字
     */
    LSPacketCommandC3=0XC3,
    
    /**********************************************/
    
    /**
     * 旧微信来电手环，设备信息数据包命令字
     */
    LSPacketCommand80=0X80,
    /**
     * 旧微信来电手环，手环每小时步数测量数据包命令字
     */
    LSPacketCommand82=0X82,
    /**
     * 旧微信来电手环，手环每天步数测量数据包命令字
     */
    LSPacketCommand8B=0X8B,
    /**
     * 旧微信来电手环，手环睡眠数据包命令字
     */
    LSPacketCommand83=0X83,
    /**
     * 旧微信来电手环，信息设置确认数据包命令字，如闹钟
     */
    LSPacketCommand8C=0X8C,
    
    /**********************************************/
    
    /**
     * A5协议手环
     * 手环信息数据包命令字
     */
    LSPacketDeviceInfo=0X50,
    /**
     * A5协议手环
     * 手环每天步数测量数据包命令字
     */
    LSPacketDataDailySteps=0X51,
    /**
     * A5协议手环
     * 手环每小时的步数测量数据命令字
     */
    LSPacketDataPerhourSteps=0X57,
    /**
     * A5协议手环
     * 睡眠数据包命令字
     */
    LSPacketDataSleep=0X52,
    /**
     * A5协议手环
     * 心率数据包命令字
     */
    LSPacketDataHeartRate=0X53,
    /**
     * A5协议手环
     * 手环游泳圈数测量数据命令字
     */
    LSPacketDataSwimminglaps=0X64,
    /**
     * A5协议手环，心率区间统计数据
     */
    LSPacketDataHeartRateStatistics=0x75,
    /**
     * A5协议手环
     * 血氧数据
     */
    LSPacketDataBloodOxygen=0X65,
    /**
     * A5协议手环
     * 跑步状态数据
     */
    LSPacketDataRunningStatus=0X72,
    /**
     * A5协议手环
     * 跑步心率数据
     */
    LSPacketDataRunningHeartRate=0X73,
    /**
     * A5协议手环
     * 跑步卡路里
     */
    LSPacketDataRunningCalorie=0X7F,
    
    /**
     * A5协议手环
     * 设备上传配置信息数据包命令字
     */
    LSPacketDataDeviceConfigInfo=0X67,
    
    /**
     * 运动模式通知命令字
     */
    LSPacketDataSportsModeNotify=0xE1,
    
    /**
     * 运动模式状态数据，命令字
     */
    LSPacketDataSportStatus=0xE2,
    
    /**
     * 运动配速数据，命令字
     */
    LSPacketDataSportsSpeed=0xE4,
    
    /**********************************************/
    
    /**
     * A5协议手环
     * 配对的随机码，命令字
     */
    LSPacketDataPairingRandomNumber=0x7B,
    
    /**
     * A5协议手环
     * 确认配对，命令字
     */
    LSPacketDataPairConfirm=0xE3,
    
    
    /**********************************************/
    
#pragma mark - Added in version 1.1.3
    
    /**
     * 心跳数据包命令字
     */
    LSPacketDataHeartbeat=0xE8,
    
    /**
     * 心跳采集功能开关
     */
    LSPacketPushFunctionSwitch=0xAD,
    
#pragma mark - Added in Version 1.1.4
    
    /**
     * 血糖仪设备信息命令字
     */
    LSPacketCommand98=0X98,
    
    /**
     * 血糖仪设备测量数据
     */
    LSPacketCommand99=0X99,
    
#pragma  mark - Added in version 1.1.8
    
    /**
     * 行为提醒，如喝水提醒
     */
    LSPacketPushBehaviorRemind=0xB0,
    
#pragma mark - Added in version 1.2.1

    /**
     * 手环上传的控制命令
     */
    LSPacketDataRemoteControl=0xC0,
    
    /**
     * 设备消息，如健康分数信息
     */
    LSPacketPushDeviceMessage=0xB1,
    
    /**
     * APP push 申请发起/结束运动（0xAF）
     */
    LSPacketPushSportRequest=0xAF,
    
    /**
     * 设备状态数据，如响应App申请发起的运动状态
     * 0xEB
     */
     LSPacketDataDeviceStatus=0xEB,

#pragma mark - Added in version 1.2.4
    
    /**
     * APP push 心情记录信息
     */
    LSPacketPushMoodReminder=0xB2,

    /**
     * 发送随机间隔数据（自定义数据）
     * 如心情记录数据
     */
    LSPacketDataCustomMeasurement=0xC1,
    
#pragma mark - Added in version 1.2.5
    
    /**
     * App Puch Kchiing 多类型、多功能提醒设置接口
     */
    LSPacketPushKchiingReminder=0xB4,
    
    /**
     * Kchiing Reminder Confirm
     */
    LSPacketDataKchiingReminderConfirm=0xC2,
    
#pragma mark - Added in version 1.2.6
    
    /**
     * App push 勿扰模式设置到M5手环
     */
    LSPacketPushQuietModeSetting=0xB3,
    
    /**
     * App push 勿扰模式设置到M5手环
     */
    LSPacketPushUserInfoM5=0xB5,
    
    /**
     * App push 应用消息提醒的AppId设置到M5手环
     */
    LSPacketPushAppIdMessage=0xB6,
    
    
    /**
     * App push 自定义提醒，如喝水提醒、加餐、睡觉提醒
     */
    LSPacketPushReminder=0xB8,
    
};

#pragma mark - Added in version 1.0.6

#pragma mark - LSBroadcastNameMatchWay

/**
 * 广播名称的匹配方式
 */
typedef NS_ENUM(NSUInteger,LSBroadcastNameMatchWay)
{
    LSBroadcastNameMatchPrefix=1,               //前缀匹配，区分大小写
    LSBroadcastNameMatchPrefixIgnoreCase=2,     //前缀匹配，不区分大小写
    LSBroadcastNameMatchSuffix=3,               //后缀匹配，区分大小写
    LSBroadcastNameMatchSuffixIgnoreCase=4,     //后缀匹配，不区分大小写
    LSBroadcastNameMatchEquals=5,               //直接比较，区分大小写
    LSBroadcastNameMatchEqualsIgnoreCase=6,     //直接比较，不区分大小写
};

#pragma mark - Added In Version 1.1.0

typedef NS_ENUM(NSUInteger,LSScaleCommandProfile)
{
    LSScaleCmdUnknown=0x00,
    LSScaleCmdRegisterDeviceID=0x0001,       //注册设备ID通知
    LSScaleCmdResponseDeviceID=0x0002,       //设备对App注册设备ID通知的响应
    LSScaleCmdBinding=0x0003,                //绑定通知
    LSScaleCmdResponseBind=0x0004,           //设备对App绑定通知的响应
    LSScaleCmdUnbinding=0x0005,              //解绑通知
    LSScaleCmdResponseUnbind=0x0006,         //设备对App解绑通知的响应
    LSScaleCmdRequestAuth=0x0007,            //设备上传的登录请求
    LSScaleCmdResponseAuth=0x0008,           //App对设备上传的登录请求进行响应
    LSScaleCmdRequestInit=0x0009,            //设备上传的初始化请求
    LSScaleCmdResponseInit=0x000A,           //App对设备上传的初始化请求进行响应
    
#pragma mark - psuh cmd
    
    LSScaleCmdResponseSetting=0x1000,        //设备对App的push指令响应
    LSScaleCmdPushUserInfo=0x1001,           //App写用户信息指令
    LSScaleCmdPushTime=0x1002,               //App写时间指令
    LSScaleCmdPushTarget=0x1003,             //App写目标信息指令
    LSScaleCmdPushUnit=0x1004,               //App写单位信息指令
    LSScaleCmdPushClearData=0x1005,          //App写清除数据指令
    
    
#pragma mark - scale's info cmd
    
    LSScaleCmdResponseSettingInfo=0x2000,    //App对设备上传的设置信息，响应码
    LSScaleCmdUserInfo=0x2001,               //设备上传用户信息，响应码
    LSScaleCmdTargetInfo=0x2003,             //设备上传目标信息
    LSScaleCmdUnitInfo=0x2004,               //设备上传单位信息
    
#pragma mark - scale's measure data cmd
    
    LSScaleCmdSyncingData=0x4801,           //App写数据同步通知命令字
    LSScaleCmdMeasureData=0x4802,           //设备上传测量数据，命令字
    
    LSScaleCmdResponseSettingBpm=0x1100,     //设备对App的push指令响应

    LSScaleCmdSyncingDataBpm=0x4901,           //App写数据同步通知命令字
    LSScaleCmdMeasureDataBpm=0x4902,           //设备上传测量数据，命令字
};

/**
 * 互联秤，测量数据包包括的数据类型
 */
typedef NS_OPTIONS(NSUInteger, LSMeasureDataType)
{
    LSMeasureDataTypeUserNumber = 1,            // 包含UserNumber
    LSMeasureDataTypeUTC = 1 << 1,              // 包含UTC
    LSMeasureDataTypeTimeZone = 1 << 2,         // 包含时区
    LSMeasureDataTypeDate = 1 << 3,             // 包含日期
    LSMeasureDataTypeBMI = 1 << 4,              // 包含BMI
    LSMeasureDataTypeBFP = 1 << 5,              // 包含Body Fat Percentage
    LSMeasureDataTypeBM = 1 << 6,               // 包含BM
    LSMeasureDataTypeMP = 1 << 7,               // 包含Muscle Percentage
    LSMeasureDataTypeMM = 1 << 8,               // 包含Muscle Mass
    LSMeasureDataTypeFFM = 1 << 9,              // 包含Fat Free Mass
    LSMeasureDataTypeSLM = 1 << 10,             // 包含Soft Lean Mass
    LSMeasureDataTypeBWM = 1 << 11,             // 包含Body Water Mass
    LSMeasureDataTypeImp = 1 << 12,             // 包含阻抗
    LSMeasureDataTypeRealtimeData= 1 << 13,     //实时数据标志位
};

/**
 * 设备数据删除类型
 */
typedef NS_OPTIONS(NSUInteger, LSDataClearType)
{
    LSClearAllData       = 1 ,              //删除所有数据
    LSClearUserData      = 1 << 1,          //删除用户数据
    LSClearSettingData   = 1 << 2,          //删除设备的设置信息数据
    LSClearMeasureData   = 1 << 3           //删除设备的测量数据
};

//时间标记类型
typedef NS_OPTIONS(NSUInteger, LSDeviceTimeFeature)
{
    LSDeviceTimeUtc       = 1 ,           //支持使用UTC时间
    LSDeviceTimeZone      = 1 << 1,       //支持使用时区
    LSDeviceTimeStamp     = 1 << 2,       //支持使用time stamp
};

#pragma mark - Added In Version 1.1.3

//设备功能
typedef  NS_ENUM(NSUInteger,LSDeviceFunction)
{
    LSDeviceFunctionHeartbeat=0x0100,          //0x0100：Qdesigne
    LSDeviceFunctionTurnOnScreen=0x0200,       //HealthMax(抬腕电量开关)
    LSDeviceFunctionManualExercise=0x0300,     //HealthMax(控制进入手动跑步模式)
    LSDeviceFunctionLowBatteryReminder=0x0400, //心情手环（是否开启低电量震动提醒）
    LSDeviceFunctionScrollDisplay=0x0500,      //信息滚动显示
};

#pragma mark - Added in version 1.1.8

//运动卡路里数据类型
typedef NS_ENUM(NSUInteger,LSSportCaloriesDataType)
{
    //旧运动卡路里数据
    LSSportCaloriesDataTypeOld,
    //新运动卡路里数据
    LSSportCaloriesDataTypeNew,
};

//运动心率数据类型
typedef NS_ENUM(NSUInteger,LSSportHartDataType)
{
    //旧运动心率数据
    LSSportHartDataTypeOld,
    //新运动心率数据
    LSSportHartDataTypeNew,
};

//手环发送运动健走子模式类型
typedef NS_ENUM(NSUInteger, LSWalkingSubModeType)
{
    //手动进入健走模式
    LSWalkingSubModeTypeManuallyEnter,
    //自动识别健走模式
    LSWalkingSubModeTypeAutomaticEnter,
};

//手环发送新跑步子模式类型
typedef NS_ENUM(NSUInteger, LSRunningSubModeType)
{
    //手动进入跑步模式
    LSRunningSubModeTypeManuallyEnter,
    //自动识别跑步模式
    LSRunningSubModeTypeAutomaticEnter,
};


// 手环发送运动子模式类型 (骑行健身足篮排羽毛乒乓球瑜伽)
typedef NS_ENUM(NSUInteger, LSSportBallSubModeType)
{
    //手动进入骑行模式
    LSSportBallSubModeTypeManuallyEnter,
    //自动识别骑行模式
    LSSportBallSubModeTypeAutomaticEnter
};

/**
 * 设备行为提醒类型
 */
typedef NS_ENUM(NSUInteger,LSReminderType){
    LSReminderTypeAlarmClock=0x00,        //普通闹钟提醒 (index1~5,支持5个)
    
    LSReminderTypeDrinkWater=0x01,         //喝水提醒
    LSReminderTypeAddMeal=0x02,            //加餐提醒
    LSReminderTypeSleep=0x03,              //睡觉提醒
};

/**
 * 手环上传的远程控制操作指令
 */
typedef NS_ENUM(NSUInteger,LSRemoteControlCmd){
    //未知
    LSRemoteControlCmdUnknown=0x00,
    /**
     * Emergency Alarm
     * 紧急报警功能
     */
     LSRemoteControlCmdEmergencyAlarm=0x01,
    
    /**
     * Looking for mobile phones
     * 寻找手机功能
     */
     LSRemoteControlCmdPhoneLocation=0x02,
    
    /**
     * Remote Photograph
     * 遥控拍照
     */
     LSRemoteControlCmdPhotograph=0x03,
    
    /**
     * Play Music
     * 播放音乐
     */
     LSRemoteControlCmdPlayMusic=0x04,
    
    /**
     * Pause Music
     * 暂停音乐播放
     */
     LSRemoteControlCmdPauseMusic=0x05,
    
    /**
     * previous music
     * 上一首
     */
     LSRemoteControlCmdPreviousMusic=0x06,
    
    /**
     * next music
     * 下一首
     */
     LSRemoteControlCmdNextMusic=0x07,
};

/**
 * 手机GPS状态
 */
typedef NS_ENUM(NSUInteger,LSGpsState){
    
    LSGpsStateUnavailable=0x00,         //GPS不可用
    LSGpsStatePositioningFailure=0x01,  //GPS开&尚未定位
    LSGpsStatePositioningSuccess=0x03,  //GPS开&定位成功
    LSGpsStateRefuse=0x80,              //手机app拒绝运动发起
};


#endif /* LSBluetoothManagerProfiles_h */
