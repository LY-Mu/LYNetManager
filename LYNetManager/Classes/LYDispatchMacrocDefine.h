//
//  LYDispatchMacrocDefine.h
//  ChessPlatform
//
//  Created by Mu on 2019/3/26.
//  Copyright © 2019 Chess. All rights reserved.
//
/**
 *  文件描述
 *
 *  这个工具类宏可以方便在各种队列中执行block,提供便捷的使用方法
 *  是对GCD的一个简单封装
 */

#import "LYDispatchCenterUitil.h"

/**
 *  主线程异步执行block
 */
#define LYAsyncMainQueue(block) [LYDispatchCenterUitil asyncMainQueue:block]

/**
 *  主线程延迟second秒异步执行block
 */
#define LYAsyncMainQueueDelay(second,block) [LYDispatchCenterUitil asyncMainQueue:block delay:second]

/**
 *  全局后台线程异步执行block
 */
#define LYAsyncGlobalBackgroundQueue(block) [LYDispatchCenterUitil asyncGlobalBackgroundQueue:block]

/**
 *  全局后台线程延迟second秒异步执行block
 */
#define LYAsyncGlobalBackgroundQueueDelay(second,block) [LYDispatchCenterUitil asyncGlobalBackgroundQueue:block delay:second]

/**
 *  全局高优先级线程异步执行block
 */
#define LYAsyncGlobalHighQueue(block) [LYDispatchCenterUitil asyncGlobalHighQueue:block]

/**
 *  全局高优先级线程延迟second秒异步执行block
 */
#define LYAsyncGlobalHighQueueDelay(second,block) [LYDispatchCenterUitil asyncGlobalHighQueue:block delay:second]

/**
 *  全局低优先级线程异步执行block
 */
#define LYAsyncGlobalLowQueue(block) [LYDispatchCenterUitil asyncGlobalLowQueue:block]

/**
 *  全局低优先级线程延迟second秒异步执行block
 */
#define LYAsyncGlobalLowQueueDelay(second,block) [LYDispatchCenterUitil asyncGlobalLowQueue:block delay:second]

/**
 *  全局默认线程异步执行block
 */
#define LYAsyncGlobalDefaultQueue(block) [LYDispatchCenterUitil asyncGlobalDefaultQueue:block]

/**
 *  全局默认线程延迟second秒异步执行block
 */
#define LYAsyncGlobalDefaultQueueDelay(second,block) [LYDispatchCenterUitil asyncGlobalDefaultQueue:block delay:second]

/**
 *  在queue线程队列异步执行block
 */
#define LYAsync(queue,block)  [LYDispatchCenterUitil asyncQueue:queue action:block]

/**
 *  在queue线程序延迟second秒异步执行block
 */
#define LYAsyncDelay(queue,second,block)  [LYDispatchCenterUitil asyncQueue:queue action:block delay:second]

/**
 *  只执行一次block,创建单例使用
 */
#define LYDispatchOnce(onceToken,block) [LYDispatchCenterUitil dispatchOnce:onceToken action:block]

/**
 *  主线程异步
 */
#define LYAsyncMainThread(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
/**
 *  全局异步执行
 */
#define LYAsyncOpenGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
