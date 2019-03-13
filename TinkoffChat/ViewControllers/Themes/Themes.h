//
//  Themes.h
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 01/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Themes: NSObject
@property (nonatomic, strong, getter=getTheme1Color, setter=setTheme1Color:) UIColor *theme1;
@property (nonatomic, strong, getter=getTheme2Color, setter=setTheme2Color:) UIColor *theme2;
@property (nonatomic, strong, getter=getTheme3Color, setter=setTheme3Color:) UIColor *theme3;
@property (nonatomic, strong) UIColor *randomColor; //bonus random color

@end
