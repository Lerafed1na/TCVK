//
//  Themes.m
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 01/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

#import "Themes.h"

@implementation Themes
@synthesize theme1 = _theme1, theme2 = _theme2, theme3 = _theme3;

- (void)dealloc {
	[_theme1 release];
	[_theme2 release];
	[_theme3 release];
	[super dealloc];
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_theme1 = [[UIColor alloc] initWithRed:224/255.f green:130/255.f blue:131/255.f alpha:1.f];
		_theme2 = [[UIColor alloc] initWithRed:213/255.f green:184/255.f blue:255/255.f alpha:1.f];
		_theme3 = [[UIColor alloc] initWithRed:240/255.f green:255/255.f blue:0/255.f alpha:1.f];
	}
	return self;
}

- (UIColor *)getTheme1Color {
	NSLog(@"Theme1 color is taken!");
	return _theme1;
}

- (void)setTheme1Color:(UIColor *)theme1 {
	if (_theme1 != theme1)
		NSLog(@"Theme1 color - %@ is changed to color - %@", _theme1, theme1);
		_theme1 = [theme1 copy];
}

- (UIColor *)getTheme2Color {
    NSLog(@"Theme2 color is taken!");
	return _theme2;
}

- (void)setTheme2Color:(UIColor *)theme2 {
	if (_theme2 != theme2) {
        NSLog(@"Theme2 color - %@ is changed to color - %@", _theme2, theme2);
		_theme2 = [theme2 copy];
	}
}

- (UIColor *)getTheme3Color {
    NSLog(@"Theme3 color is taken!");
	return _theme3;
}

- (void)setTheme3Color:(UIColor *)theme3 {
	if (_theme3 != theme3) {
        NSLog(@"Theme3 color - %@ is changed to color - %@", _theme3, theme3);
		_theme3 = [theme3 copy];
	}
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end



