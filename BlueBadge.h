//
//  BlueBadge.m
//
//  Copyright 2008 Stepcase Limited.
//  Modifications 2009 Joshua Gross to support custom colors, UIImage conversion and colors
//  Requires UIColor-Expanded: http://github.com/ars/uicolor-utilities/tree/master
//

#import <UIKit/UIKit.h>


@interface BlueBadge : UIView
{
	NSInteger count;
	UIColor* badgeColor;
	
	NSInteger offsetX;
	NSInteger offsetY;
	NSInteger fontSize;
}

@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger offsetX;
@property (nonatomic) NSInteger offsetY;
@property (nonatomic) NSInteger fontSize;
@property (nonatomic, retain) UIColor* badgeColor;

-(void)drawWithCount:(NSInteger)i;
-(UIImage*)viewImage;

@end
