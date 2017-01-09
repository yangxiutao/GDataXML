//
//  XMLManager.m
//  HandelXMLFile
//
//  Created by YXT on 2017/1/9.
//  Copyright © 2017年 YXT. All rights reserved.
//

#import "XMLManager.h"
#import <GDataXMLNode.h>

@interface XMLManager ()

@end

@implementation XMLManager

+ (void)xmlAnalysis:(void (^)(NSString *))success{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /** 获取 xml 文件路径 */
        NSString *xmlFilePath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"xml"];
        
        BOOL isXMLFileExist = [[NSFileManager defaultManager]fileExistsAtPath:xmlFilePath];
        NSAssert(isXMLFileExist, @"The xml file doesn't exist!");
        
        /** 获取 xml 数据 */
        
        NSData *xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
        
        /** 将 xmlData 转换成 plist */
        NSError *xmlTransPlistError = nil;
        GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc]initWithData:xmlData error:&xmlTransPlistError];
        if (xmlTransPlistError) {
            
            return;
        }
        
        /** 获取根节点 */
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        
        /** 获取省节点 */
        NSArray *provinceElements = [rootElement elementsForName:@"province"];
        NSMutableArray *mProvinceArray = [NSMutableArray array];
        for (GDataXMLElement *proviceElement in provinceElements) {
            
            /** 获取省名称 */
            NSString *proviceName = [[proviceElement attributeForName:@"name"] stringValue];
            
            NSString *provicenZipCode = [[proviceElement attributeForName:@"zipcode"] stringValue];
            
            
            /** 获取市节点 */
            NSArray *cityElements = [proviceElement elementsForName:@"city"];
            
            NSMutableArray *mCities = [NSMutableArray array];
            for (GDataXMLElement *cityElement in cityElements) {
                
                /** 获取市名称 */
                NSString *cityName = [[cityElement attributeForName:@"name"] stringValue];
                
                NSString *cityZipCode = [[cityElement attributeForName:@"zipcode"] stringValue];
                
                /** 获取市内地区节点 */
                NSArray *districtElements = [cityElement elementsForName:@"district"];
                NSMutableArray *mCityAreaArray = [NSMutableArray array]; //
                for (GDataXMLElement *districtElement in districtElements) {
                    
                    /** 获取市内辖区名称 */
                    NSString *districtName = [[districtElement attributeForName:@"name"] stringValue];
                    
                    NSString *districtZipCode = [[districtElement attributeForName:@"zipcode"] stringValue];
                    
                    NSDictionary *districDictionary = @{@"state":districtName, @"zipcode":districtZipCode};
                    [mCityAreaArray addObject:districDictionary];
                }
                
                NSDictionary *cityDictionary = @{@"state":cityName, @"cities":mCityAreaArray, @"zipcode":cityZipCode};
                [mCities addObject:cityDictionary];
            }
            
            NSDictionary *provinceDictionary = @{@"state":proviceName, @"cities":mCities, @"zipcode":provicenZipCode};
            [mProvinceArray addObject:provinceDictionary];
            
        }
        
        NSArray *plistPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [[plistPathArray objectAtIndex:0] stringByAppendingPathComponent:@"country.plist"];
        /** 将数据写入 plist 文件 */
        [mProvinceArray writeToFile:plistPath atomically:YES];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            success(plistPath);
        });
    });
    
}

@end
