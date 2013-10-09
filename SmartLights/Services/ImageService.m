//
//  ImageService.m
//  SmartLights
//
//  Created by Xu Huanze on 10/2/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "ImageService.h"

@implementation ImageService
+(UIImage *)fillImage:(UIImage*)img withColor:(UIColor *)color
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const float* colors = CGColorGetComponents( color.CGColor );
    UIColor* newColor = [[UIColor alloc] initWithRed:colors[0] green:colors[1] blue:colors[2] alpha:1];
    // set the fill color
    [newColor setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}
@end
