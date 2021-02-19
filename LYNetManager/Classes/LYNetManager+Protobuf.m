//
//  LYNetManager+Protobuf.m
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "LYNetManager+Protobuf.h"

@implementation LYNetManager (Protobuf)

+ (LYURLSessionTask *)ly_protobufGet:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
      failureBlock:(LYResponseFailBlock)failureBlock
{
    LYDataEntity *entity = [[LYDataEntity alloc] init];
    entity.urlString = url;
    entity.parameters = params;
    entity.headers = headers;
    [LYNetManager ly_setRedPackWithProtobuf];
    return [LYNetManager ly_request_GETWithEntity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:nil];
}

+ (LYURLSessionTask *)ly_protobufPost:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
       failureBlock:(LYResponseFailBlock)failureBlock
{
    LYDataEntity *entity = [[LYDataEntity alloc] init];
    entity.urlString = url;
    entity.parameters = params;
    entity.headers = headers;
    
    [LYNetManager ly_setRedPackWithProtobuf];
    return [LYNetManager ly_request_POSTWithEntity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:nil];
}
@end
