//
//  QFGetOneImage.h
//  TestImage
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFGetOneImage : NSObject

+ (QFGetOneImage *)share;
- (void)getImageWithKeywords:(NSString *)keywords toFolderPath:(NSString *)path;

@end

