//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 28/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()
@end

@implementation ThemesViewController
@synthesize delegate = _delegate, model = _model;

- (void)dealloc {
	[_model release];
	[super dealloc];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_model = [Themes new];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.firstButton setBackgroundColor:self.model.theme1];
	[self.secondButton setBackgroundColor:self.model.theme2];
	[self.thirdButton setBackgroundColor:self.model.theme3];
    [self.randomButton setBackgroundColor:[UIColor whiteColor]];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedColor"];
    if ([NSKeyedUnarchiver unarchiveObjectWithData:colorData]) {
        UINavigationBar.appearance.barTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        self.view.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}


-(Themes*)model {
    return _model;
}

-(void)setModel:(Themes *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
}

-(id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}

-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
	UIColor *selectedColor = nil;

	if (sender == self.firstButton) {
		selectedColor = self.model.theme1;
		
	} else if (sender == self.secondButton) {
		selectedColor = self.model.theme2;

    } else if (sender == self.thirdButton) {
        selectedColor = self.model.theme3;
        
    } else {
        selectedColor = self.model.randomColor;
    }

	self.view.backgroundColor = selectedColor;
	[self.delegate themesViewController:self didSelectTheme:selectedColor];
    [[UINavigationBar appearance] setBarTintColor:selectedColor];
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:selectedColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"selectedColor"];
    
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}

@end

