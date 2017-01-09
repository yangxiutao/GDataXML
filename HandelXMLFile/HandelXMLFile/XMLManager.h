//
//  XMLManager.h
//  HandelXMLFile
//
//  Created by YXT on 2017/1/9.
//  Copyright © 2017年 YXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLManager : NSObject

+ (void)xmlAnalysis:(void(^)(NSString *filePath))success;

@end
