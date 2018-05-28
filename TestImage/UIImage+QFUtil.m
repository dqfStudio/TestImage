//
//  UIImage+QFUtil.m
//  TestImage
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIImage+QFUtil.h"

@implementation UIImage (QFUtil)

- (UIImage *)watermarkWithName:(NSString *)name {
    
    NSString *mark = name;
    int w = self.size.width;
    int h = self.size.height;
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:40],
                           NSForegroundColorAttributeName : [UIColor redColor]};
    
    [mark drawInRect:CGRectMake(0, 0, w, 60) withAttributes:attr];//左上角
    UIImage *aImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aImg;
}

@end
