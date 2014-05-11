//
//  UIView+ColorOfPoint.m
//
//  Created by Ivan Zezyulya on 12.01.11.
//

#import "UIView+ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (ColorOfPoint)

- (UIColor *) colorOfPoint:(CGPoint)point
{
	unsigned char pixel[4] = {0};

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
	CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
	CGContextTranslateCTM(context, -point.x, -point.y);

	[self.layer renderInContext:context];
    CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
    NSLog(@"create context: %.3f, render: %.3f", t1-start, t2-t1);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	//NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);

	UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];

	return color;
}


- (unsigned char*) getImageData{
	CGImageRef inImage = self.image.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { return nil; /* error */ }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}};
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage);
    
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
    // When finished, release the context
	CGContextRelease(cgctx);
    return data;
}

//- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
//	UIColor* color = nil;
//	CGImageRef inImage = self.image.CGImage;
//	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
//	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
//	if (cgctx == NULL) { return nil; /* error */ }
//	
//    size_t w = CGImageGetWidth(inImage);
//	size_t h = CGImageGetHeight(inImage);
//	CGRect rect = {{0,0},{w,h}};
//	
//	// Draw the image to the bitmap context. Once we draw, the memory
//	// allocated for the context for rendering will then contain the
//	// raw image data in the specified color space.
//	CGContextDrawImage(cgctx, rect, inImage);
//	
//	// Now we can get a pointer to the image data associated with the bitmap
//	// context.
//	unsigned char* data = CGBitmapContextGetData (cgctx);
//	if (data != NULL) {
//		//offset locates the pixel in the data from x,y.
//		//4 for 4 bytes of data per pixel, w is width of one row of data.
//		int offset = 4*((w*round(point.y))+round(point.x));
//		int alpha =  data[offset];
//		int red = data[offset+1];
//		int green = data[offset+2];
//		int blue = data[offset+3];
////		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
//		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
//	}
//	
//	// When finished, release the context
//	CGContextRelease(cgctx);
//	// Free image data memory for the context
//	if (data) { free(data); }
//	
//	return color;
//}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

- (UIColor*)colorAtPoint:(CGPoint)point{
    UIImage* image = self.image;
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * point.y) + point.x ) * 4; // The image is png
    
    UInt8 red = data[pixelInfo];         // If you need this info, enable it
    UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
}

@end
