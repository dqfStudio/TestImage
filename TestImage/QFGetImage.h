//
//  QFGetImage.h
//  TestImage
//
//  Created by dqf on 2017/9/22.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFGetImage : NSObject

+ (QFGetImage *)share;
- (void)getImageWithKeywords:(NSString *)keywords toFolderPath:(NSString *)path;

@end
