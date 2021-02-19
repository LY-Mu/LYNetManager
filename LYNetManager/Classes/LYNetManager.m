//
//  LYNetManager.m
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "LYNetManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

/*! 系统相册 */
#import <Photos/Photos.h>
//#import "AFNetworking.h"
//#import "AFNetworkActivityIndicatorManager.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "UIImage+LYCompressImage.h"
#import "LYNetManagerCache.h"

// 兼容 protobuf 的解析类
#import "LYHTTPResponseSerializer.h"
#import "LYHTTPRequestSerializer.h"

static NSMutableArray *tasks;

//static void *isNeedCacheKey = @"isNeedCacheKey";

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

@interface LYNetManager ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation LYNetManager

+ (instancetype)sharedLYNetManager {
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedLYNetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLYNetManager = [[super allocWithZone:NULL] init];
    });
    return sharedLYNetManager;
}

+ (void)initialize {
    [self setupLYNetManager];
}

+ (void)setupLYNetManager {
    LYNetManagerShare.sessionManager = [AFHTTPSessionManager manager];
    /*! 设置请求超时时间，默认：30秒 */
    LYNetManagerShare.timeoutInterval = 15;
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 设置响应数据的基本类型 */
    LYNetManagerShare.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*",@"application/octet-stream",@"application/x-protobuf", nil];
    // 配置自建证书的Https请求
//    [self ly_setupSecurityPolicy];
    
//    LYNetManagerShare.sessionManager.requestSerializer = [LYHTTPRequestSerializer serializer] ;
//    LYNetManagerShare.sessionManager.responseSerializer = [LYHTTPResponseSerializer serializer] ;
}

/**
 配置自建证书的Https请求，只需要将CA证书文件放入根目录就行
 */
+ (void)ly_setupSecurityPolicy {
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    
    if (cerSet.count == 0) {
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        LYNetManagerShare.sessionManager.securityPolicy = securityPolicy;
    } else {
        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        // 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        // 如果需要验证自建证书(无效证书)，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // 是否需要验证域名，默认为YES
        //    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
        
        LYNetManagerShare.sessionManager.securityPolicy = securityPolicy;
        
        
        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //            NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //            policy.allowInvalidCertificates = YES;
        //            LYNetManagerShare.sessionManager.securityPolicy = policy;
    }
}

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param entity    entity
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progressBlock 进度
 */
+ (LYURLSessionTask *)ly_requestWithType:(LYHttpRequestType)type
                                  entity:(LYDataEntity *)entity
                            successBlock:(LYResponseSuccessBlock)successBlock
                            failureBlock:(LYResponseFailBlock)failureBlock
                           progressBlock:(LYDownloadProgressBlock)progressBlock {
    if ( entity.urlString == nil) {
        return nil;
    }
    
    LYWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:entity.urlString] ? entity.urlString : [self strUTF8Encoding:entity.urlString];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        case 2:
            requestType = @"PUT";
            break;
        case 3:
            requestType = @"DELETE";
            break;
            
        default:
            break;
    }
    
    AFHTTPSessionManager *scc = LYNetManagerShare.sessionManager;
    AFHTTPResponseSerializer *scc2 = scc.responseSerializer;
    AFHTTPRequestSerializer *scc3 = scc.requestSerializer;
    NSTimeInterval timeoutInterval = LYNetManagerShare.timeoutInterval;
    
    NSString *isCache = entity.isNeedCache ? @"开启":@"关闭";
    CGFloat allCacheSize = [LYNetManagerCache ly_getAllHttpCacheSize];
    
    if (LYNetManagerShare.isOpenLog) {
        NSLog(@"\n******************** 请求参数 ***************************");
        NSLog(@"\n请求头: %@\n超时时间设置：%.1f 秒【默认：30秒】\nAFHTTPResponseSerializer：%@【默认：AFJSONResponseSerializer】\nAFHTTPRequestSerializer：%@【默认：AFJSONRequestSerializer】\n请求方式: %@\n请求URL: %@\n请求param: %@\n是否启用缓存：%@【默认：开启】\n目前总缓存大小：%.6fM\n", LYNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, timeoutInterval, scc2, scc3, requestType, URLString, entity.parameters, isCache, allCacheSize);
        NSLog(@"\n********************************************************");
    }

    LYURLSessionTask *sessionTask = nil;
    
    // 读取缓存
    id responseCacheData = [LYNetManagerCache ly_httpCacheWithUrlString:entity.urlString parameters:entity.parameters];
    
    if (entity.isNeedCache && responseCacheData != nil) {
        if (successBlock) {
            successBlock(responseCacheData);
        }
        if (LYNetManagerShare.isOpenLog) {
            NSLog(@"取用缓存数据结果： *** %@", responseCacheData);
        }
        [[weakSelf tasks] removeObject:sessionTask];
        return nil;
    }
    
    if (entity.isSetQueryStringSerialization) {
        [LYNetManagerShare.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            
            return parameters;
            
        }];
    }
    
    if (type == LYHttpRequestTypeGet) {
        sessionTask = [LYNetManagerShare.sessionManager GET:URLString parameters:entity.parameters headers:entity.headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock) {
                successBlock(responseObject);
            }
            // 对数据进行异步缓存
            [LYNetManagerCache ly_setHttpCache:responseObject urlString:entity.urlString parameters:entity.parameters];
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    } else if (type == LYHttpRequestTypePost) {
        sessionTask = [LYNetManagerShare.sessionManager POST:URLString parameters:entity.parameters headers:entity.headers progress:^(NSProgress * _Nonnull uploadProgress) {
            if (LYNetManagerShare.isOpenLog) {
                NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) {
                    progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                }
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (LYNetManagerShare.isOpenLog) {
                NSLog(@"post 请求数据结果： *** %@", responseObject);
            }
            if (successBlock) {
                successBlock(responseObject);
            }
            
            // 对数据进行异步缓存
            [LYNetManagerCache ly_setHttpCache:responseObject urlString:entity.urlString parameters:entity.parameters];
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);

            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    } else if (type == LYHttpRequestTypePut) {
        sessionTask = [LYNetManagerShare.sessionManager PUT:URLString parameters:entity.parameters headers:entity.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock) {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    } else if (type == LYHttpRequestTypeDelete) {
        sessionTask = [LYNetManagerShare.sessionManager DELETE:URLString parameters:entity.parameters headers:entity.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask) {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark - 网络请求的类方法 + Entity --- get / post / put / delete

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
                                 progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypeGet entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

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
                                  progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypePost entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

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
                                 progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypePut entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

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
                                    progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypeDelete entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

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
                                 progressBlock:(LYUploadProgressBlock)progressBlock {
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[LYImageDataEntity class]]) {
        return nil;
    }
    
    LYImageDataEntity *imageEntity = (LYImageDataEntity *)entity;
    
    LYWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:imageEntity.urlString] ? imageEntity.urlString : [self strUTF8Encoding:imageEntity.urlString];
    
    if (LYNetManagerShare.isOpenLog) {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",LYNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"POST",URLString, imageEntity.parameters);
        NSLog(@"********************************************************");
    }
    LYURLSessionTask *sessionTask = nil;
    sessionTask = [LYNetManagerShare.sessionManager POST:URLString parameters:imageEntity.parameters headers:entity.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*! 出于性能考虑,将上传图片进行压缩 */
        [imageEntity.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /*! image的压缩方法 */
            UIImage *resizedImage;
            /*! 此处是使用原生系统相册 */
            if ([obj isKindOfClass:[PHAsset class]]) {
                PHAsset *asset = (PHAsset *)obj;
                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth , asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (LYNetManagerShare.isOpenLog)
                    {
                        NSLog(@" width:%f height:%f",result.size.width,result.size.height);
                    }
                    [self ly_uploadImageWithFormData:formData resizedImage:result imageType:imageEntity.imageType imageScale:imageEntity.imageScale fileNames:imageEntity.fileNames index:idx];
                }];
            } else {
                /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
                [self ly_uploadImageWithFormData:formData resizedImage:resizedImage imageType:imageEntity.imageType imageScale:imageEntity.imageScale fileNames:imageEntity.fileNames index:idx];
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (LYNetManagerShare.isOpenLog) {
            NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LYNetManagerShare.isOpenLog) {
            NSLog(@"上传图片成功 = %@",responseObject);
        }
        if (successBlock) {
            successBlock(responseObject);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",error);
        if (failureBlock) {
            failureBlock(error);
        }
        [[weakSelf tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

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
                   progressBlock:(LYUploadProgressBlock)progressBlock {
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[LYFileDataEntity class]]) {
        return;
    }
    LYFileDataEntity *fileEntity = (LYFileDataEntity *)entity;
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:fileEntity.filePath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted: {
                [LYNetManagerShare.sessionManager POST:fileEntity.urlString parameters:fileEntity.parameters headers:entity.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (LYNetManagerShare.isOpenLog)
                    {
                        NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    }
                    /*! 回到主线程刷新UI */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressBlock)
                        {
                            progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                        }
                    });
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传视频成功 = %@",responseObject);
                    
                    if (successBlock)
                    {
                        successBlock(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传视频失败 = %@", error);
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

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
                                  progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[LYFileDataEntity class]]) {
        return nil;
    }
    
    LYFileDataEntity *fileEntity = (LYFileDataEntity *)entity;
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fileEntity.urlString]];
    if (LYNetManagerShare.isOpenLog) {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",LYNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"download", fileEntity.urlString, fileEntity.parameters);
        NSLog(@"******************************************************");
    }
    
    LYURLSessionTask *sessionTask = nil;
    
    sessionTask = [LYNetManagerShare.sessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (LYNetManagerShare.isOpenLog) {
            NSLog(@"下载进度：%.2lld%%",100 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!fileEntity.filePath) {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            if (LYNetManagerShare.isOpenLog) {
                NSLog(@"默认路径--%@",downloadURL);
            }
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        else {
            return [NSURL fileURLWithPath:fileEntity.filePath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self tasks] removeObject:sessionTask];
        
        NSLog(@"下载文件成功");
        if (error == nil) {
            if (successBlock) {
                /*! 返回完整路径 */
                successBlock([filePath path]);
            }
        }
        else {
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

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
                                    progressBlock:(LYUploadProgressBlock)progressBlock {
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[LYFileDataEntity class]]) {
        return nil;
    }
    
    LYFileDataEntity *fileEntity = (LYFileDataEntity *)entity;
    if (LYNetManagerShare.isOpenLog) {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",LYNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"uploadFile", fileEntity.urlString, fileEntity.parameters);
        NSLog(@"******************************************************");
    }
    LYURLSessionTask *sessionTask = nil;
    sessionTask = [LYNetManagerShare.sessionManager POST:fileEntity.urlString parameters:fileEntity.parameters headers:entity.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:fileEntity.filePath] name:fileEntity.fileName error:&error];
        if (failureBlock && error) {
            failureBlock(error);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (LYNetManagerShare.isOpenLog) {
            NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self tasks] removeObject:sessionTask];
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self tasks] removeObject:sessionTask];
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

#pragma mark - 网络状态监测
/*!
 *  开启网络监测
 */
+ (void)ly_startNetWorkMonitoringWithBlock:(LYNetworkStatusBlock)networkStatus {
    /*! 1.获得网络监控的管理者 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*! 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 2.设置网络状态改变后的处理 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*! 当网络状态改变了, 就会调用这个block */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知网络");
                networkStatus ? networkStatus(LYNetworkStatusUnknown) : nil;
            } break;
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"没有网络");
                networkStatus ? networkStatus(LYNetworkStatusNotReachable) : nil;
            } break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"手机自带网络");
                networkStatus ? networkStatus(LYNetworkStatusReachableViaWWAN) : nil;
            } break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"wifi 网络");
                networkStatus ? networkStatus(LYNetworkStatusReachableViaWiFi) : nil;
            } break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ly_cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ly_cancelRequestWithURL:(NSString *)URL {
    if (!URL) {
        return;
    }
    @synchronized (self) {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self tasks] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if (newSize.height > 375/newSize.width*newSize.height) {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375) {
        newSize.width = 375;
    }
    
    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
    return newImage;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str {
    /*! ios9适配的话 打开第一个 */
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}

#pragma mark - setter / getter
/**
 存储着所有的请求task数组
 
 @return 存储着所有的请求task数组
 */
+ (NSMutableArray *)tasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    LYNetManagerShare.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setRequestSerializer:(LYHttpRequestSerializer)requestSerializer {
    _requestSerializer = requestSerializer;
    switch (requestSerializer) {
        case LYHttpRequestSerializerJSON: {
            LYNetManagerShare.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer] ;
        } break;
        case LYHttpRequestSerializerHTTP: {
            LYNetManagerShare.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
        } break;
        case LYHttpRequestSerializerProtobuf: {
            LYNetManagerShare.sessionManager.requestSerializer = [LYHTTPRequestSerializer serializer] ;
        } break;
            
        default:
            break;
    }
}

- (void)setResponseSerializer:(LYHttpResponseSerializer)responseSerializer {
    _responseSerializer = responseSerializer;
    switch (responseSerializer) {
        case LYHttpResponseSerializerJSON: {
            LYNetManagerShare.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer] ;
        } break;
        case LYHttpResponseSerializerHTTP: {
            LYNetManagerShare.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
        } break;
        case LYHttpResponseSerializerProtobuf: {
            LYNetManagerShare.sessionManager.responseSerializer = [LYHTTPResponseSerializer serializer] ;
        } break;
            
        default:
            break;
    }
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary {
    _httpHeaderFieldDictionary = httpHeaderFieldDictionary;
    
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    
    if (keyArray.count <= 0) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    
    for (NSInteger i = 0; i < keyArray.count; i ++) {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        
        [LYNetManager ly_setValue:valueString forHTTPHeaderKey:keyString];
    }
}

/**
 *  自定义请求头
 */
+ (void)ly_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey {
    [LYNetManagerShare.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}

+ (void)ly_setHallWithForm_urlencoded
{
    [LYNetManager ly_setValue:@"*/*" forHTTPHeaderKey:@"Accept"];
    [LYNetManager ly_setValue:@"application/x-www-form-urlencoded" forHTTPHeaderKey:@"Content-Type"];
    LYNetManagerShare.requestSerializer = LYHttpRequestSerializerHTTP;
    LYNetManagerShare.responseSerializer = LYHttpResponseSerializerJSON;
}

+ (void)ly_setTyWithJson
{
    
}

+ (void)ly_setRedPackWithProtobuf
{
    [LYNetManager ly_setValue:@"application/x-protobuf" forHTTPHeaderKey:@"Accept"];
    [LYNetManager ly_setValue:@"application/x-protobuf" forHTTPHeaderKey:@"Content-Type"];
    
    LYNetManagerShare.requestSerializer = LYHttpRequestSerializerProtobuf;
    LYNetManagerShare.responseSerializer = LYHttpResponseSerializerProtobuf;
}

/**
 删除所有请求头
 */
+ (void)ly_clearAuthorizationHeader {
    [LYNetManagerShare.sessionManager.requestSerializer clearAuthorizationHeader];
}

+ (void)ly_uploadImageWithFormData:(id<AFMultipartFormData>  _Nonnull )formData
                      resizedImage:(UIImage *)resizedImage
                         imageType:(NSString *)imageType
                        imageScale:(CGFloat)imageScale
                         fileNames:(NSArray <NSString *> *)fileNames
                             index:(NSUInteger)index {
    /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
    if (imageScale == 0) {
        imageScale = 0.8;
    }
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, imageScale ?: 1.f);
    
    /*! 拼接data */
    if (imageData != nil) {   // 图片数据不为空才传递 fileName
        //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
        
        // 默认图片的文件名, 若fileNames为nil就使用
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@",str, index, imageType?:@"jpg"];
        
        [formData appendPartWithFileData:imageData
                                    name:[NSString stringWithFormat:@"picflie%ld", index]
                                fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[index],imageType?:@"jpg"] : imageFileName
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"]];
        NSLog(@"上传图片 %lu 成功", (unsigned long)index);
    }
}

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ly_clearAllHttpCache {
    [LYNetManagerCache ly_clearAllHttpCache];
}

@end

#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建 NSDictionary 与 NSArray 的分类, 控制台打印 json 数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (LYNetManager)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (LYNetManager)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end

#endif


