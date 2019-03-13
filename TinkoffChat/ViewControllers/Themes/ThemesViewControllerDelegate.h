//
//  ThemesViewControllerDelegate.h
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 03.03.19.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//
#import <Foundation/Foundation.h>

@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController *)controller
			 didSelectTheme:(UIColor *)selectedTheme;
@end
