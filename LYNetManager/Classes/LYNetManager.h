//
//  LYNetManager.h
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 LYbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYDataEntity.h"

#define LYNetManagerShare [LYNetManager sharedLYNetManager]

#define LYWeak  __weak __typeof(self) weakSelf = self

/*! 过期属性或方法名提醒 */
#define LYNetManagerDeprecated(instead) __deprecated_msg(instead)


/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, LYNetworkStatus) {
    /*! 未知网络 */
    LYNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    LYNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    LYNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    LYNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, LYHttpRequestType) {
    /*! get请求 */
    LYHttpRequestTypeGet = 0,
    /*! post请求 */
    LYHttpRequestTypePost,
    /*! put请求 */
    LYHttpRequestTypePut,
    /*! delete请求 */
    LYHttpRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, LYHttpRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    LYHttpRequestSerializerJSON,
    /** 设置请求数据为HTTP格式*/
    LYHttpRequestSerializerHTTP,
    /** 设置请求数据为Protobuf格式*/
    LYHttpRequestSerializerProtobuf,
};

typedef NS_ENUM(NSUInteger, LYHttpResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    LYHttpResponseSerializerJSON,
    /** 设置响应数据为HTTP格式*/
    LYHttpResponseSerializerHTTP,
    /** 设置响应数据为Protobuf格式*/
    LYHttpResponseSerializerProtobuf,
};

/*! 实时监测网络状态的 block */
typedef void(^LYNetworkStatusBlock)(LYNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ LYResponseSuccessBlock)(id response);
/*! 定义请求失败的 block */
typedef void( ^ LYResponseFailBlock)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ LYUploadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ LYDownloadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);

/*!
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask LYURLSessionTask;

@class LYDataEntity;

@interface LYNetManager : NSObject

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为15秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 设置网络请求参数的格式，此设置为全局统一设置一次即可，默认：LYHttpRequestSerializerJSON
 */
@property (nonatomic, assign) LYHttpRequestSerializer requestSerializer;

/**
 设置服务器响应数据格式，此设置为全局统一设置一次即可，默认：LYHttpResponseSerializerJSON
 */
@property (nonatomic, assign) LYHttpResponseSerializer responseSerializer;

/**
 自定义请求头：httpHeaderField
 */
@property(nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

/**
 是否开启 log 打印，默认不开启
 */
@property(nonatomic, assign) BOOL isOpenLog;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类LYNetManager单例
 */
+ (instancetype)sharedLYNetManager;


#pragma mark - 网络请求的类方法 --- get / post / put / delete

/**
 网络请求的实例方法 get

 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度回调
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_request_GETWithEntity:(LYDataEntity *)entity
                                  successBlock:(LYResponseSuccessBlock)successBlock
                                  failureBlock:(LYResponseFailBlock)failureBlock
                                 progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 post

 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_request_POSTWithEntity:(LYDataEntity *)entity
                                   successBlock:(LYResponseSuccessBlock)successBlock
                                   failureBlock:(LYResponseFailBlock)failureBlock
                                  progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 put
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_request_PUTWithEntity:(LYDataEntity *)entity
                                  successBlock:(LYResponseSuccessBlock)successBlock
                                  failureBlock:(LYResponseFailBlock)failureBlock
                                 progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 delete
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_request_DELETEWithEntity:(LYDataEntity *)entity
                                     successBlock:(LYResponseSuccessBlock)successBlock
                                     failureBlock:(LYResponseFailBlock)failureBlock
                                    progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 上传图片(多图)
 
 @param entity 请求信息载体
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progressBlock 上传进度
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_uploadImageWithEntity:(LYDataEntity *)entity
                                  successBlock:(LYResponseSuccessBlock)successBlock
                                   failurBlock:(LYResponseFailBlock)failureBlock
                                 progressBlock:(LYUploadProgressBlock)progressBlock;

/**
 视频上传
 
 @param entity 请求信息载体
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progressBlock 上传的进度
 */
+ (void)ly_uploadVideoWithEntity:(LYDataEntity *)entity
                    successBlock:(LYResponseSuccessBlock)successBlock
                    failureBlock:(LYResponseFailBlock)failureBlock
                   progressBlock:(LYUploadProgressBlock)progressBlock;

/**
 文件下载
 
 @param entity 请求信息载体
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progressBlock 下载文件的进度显示
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_downLoadFileWithEntity:(LYDataEntity *)entity
                                   successBlock:(LYResponseSuccessBlock)successBlock
                                   failureBlock:(LYResponseFailBlock)failureBlock
                                  progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 文件上传
 
 @param entity 请求信息载体
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 @param progressBlock progressBlock description
 @return LYURLSessionTask
 */
+ (LYURLSessionTask *)ly_uploadFileWithWithEntity:(LYDataEntity *)entity
                                     successBlock:(LYResponseSuccessBlock)successBlock
                                     failureBlock:(LYResponseFailBlock)failureBlock
                                    progressBlock:(LYUploadProgressBlock)progressBlock;


#pragma mark - 网络状态监测
/*!
 *  开启实时网络状态监测，通过Block回调实时获取(此方法可多次调用)
 */
+ (void)ly_startNetWorkMonitoringWithBlock:(LYNetworkStatusBlock)networkStatus;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)ly_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;
+ (void)ly_setHallWithForm_urlencoded;
+ (void)ly_setTyWithJson;
+ (void)ly_setRedPackWithProtobuf;
/**
 删除所有请求头
 */
+ (void)ly_clearAuthorizationHeader;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ly_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ly_cancelRequestWithURL:(NSString *)URL;

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ly_clearAllHttpCache;

@end
