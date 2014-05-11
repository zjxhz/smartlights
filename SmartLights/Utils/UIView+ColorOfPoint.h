//
//  UIView+ColorOfPoint.h
//
//  Created by Ivan Zezyulya on 12.01.11.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ColorOfPoint)

- (UIColor *) colorOfPoint:(CGPoint)point;
//- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (UIColor*)colorAtPoint:(CGPoint)point;
- (unsigned char*) getImageData;
@end
