//
//  BlueBadge.m
//
//  Copyright 2008 Stepcase Limited.
//  Modifications 2009 Joshua Gross to support custom colors, UIImage conversion and colors
//  Requires UIColor-Expanded: http://github.com/ars/uicolor-utilities/tree/master
//

#import "BlueBadge.h"
#import "UIColor-Expanded.h"

@implementation BlueBadge

@synthesize count;
@synthesize badgeColor;
@synthesize offsetX;
@synthesize offsetY;
@synthesize fontSize;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
        // Initialization code
		[self setBackgroundColor: [UIColor clearColor]];
		[self setCount: 0];
    }
	
	[self setBadgeColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.75 alpha:1.0]]; // blue
//	[self setBadgeColor:[UIColor colorWithRed:0.75 green:0.2 blue:0.15 alpha:1.0]]; // red
//	[self setBadgeColor:[UIColor colorWithRed:0.2 green:0.65 blue:0.15 alpha:1.0]]; // green
	[self setOffsetX:0];
	[self setOffsetY:0];
	[self setFontSize:16];
	
    return self;
}

-(void)drawRect:(CGRect)rect
{
	if (count == 0) return;
	NSString *countString = [NSString stringWithFormat: @"%d", count];
	UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
	CGSize numberSize = [countString sizeWithFont: font];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	float radius = numberSize.height / 2.0;
	float startPoint = (rect.size.width - (numberSize.width + numberSize.height))/2.0;
	
	// This is where uicolor-expanded is used
	CGContextSetRGBFillColor(context, [badgeColor red], [badgeColor green], [badgeColor blue], [badgeColor alpha]);
	CGContextBeginPath(context);
	CGContextAddArc(context, offsetX + startPoint + radius, offsetY + radius, radius, M_PI / 2 , 3 * M_PI / 2, NO);
	CGContextAddArc(context, offsetX + startPoint + radius + numberSize.width, offsetY + radius, radius, 3 * M_PI / 2, M_PI / 2, NO);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	[[UIColor whiteColor] set];	
	[countString drawInRect: CGRectMake(startPoint + radius + offsetX, offsetY + rect.origin.y, rect.size.width, rect.size.height) withFont: font];
}

- (void)drawWithCount:(NSInteger)i
{
	self.count = i;
	[self setNeedsDisplay];
}

// Return UIImage of badge
-(UIImage*)viewImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

- (void)dealloc
{
	[badgeColor release];
    [super dealloc];
}


@end
