//
//  BQSuperView.m
//  BQSuperViewDemo
//
//  Created by huangbq on 2017/4/4.
//  Copyright © 2017年 huangbq. All rights reserved.
//

#import "BQSuperView.h"

#define kSuperViewMargin 8

#define kSystemKeyboardWindowLevel 10000000

@implementation BQSuperViewWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.windowLevel = kSystemKeyboardWindowLevel;
    }
    return self;
}

@end

@implementation BQSuperViewController

@end

@implementation BQSuperView
{
    BQSuperViewWindow *_superviewWindow;
    CGRect _currentFrame;
}

#pragma mark - life cycle

- (void)dealloc {
    if (_superviewWindow != nil) {
        _superviewWindow.hidden = YES;
        _superviewWindow.rootViewController = nil;
        _superviewWindow = nil;
    }
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BQSuperViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.8;
        self.delegate = delegate;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.delaysTouchesBegan = YES;
        [self addGestureRecognizer:panGesture];
        [self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _superviewWindow = nil;
        _currentFrame = frame;
        
        // add keyboard observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        
    }
    
    return self;
}


#pragma mark - public methods
- (void)show {
    
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSLog(@"super view frame: %@", NSStringFromCGRect(self.frame));
    if (!_superviewWindow) {
        _superviewWindow = [[BQSuperViewWindow alloc] initWithFrame:_currentFrame];
        _superviewWindow.rootViewController = [ BQSuperViewController new];
    } else {
        _superviewWindow.frame = _currentFrame;
    }
    
    [_superviewWindow makeKeyAndVisible];
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.layer.cornerRadius = self.frame.size.width <= self.frame.size.height ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0;
    
    [_superviewWindow addSubview:self];
    
    // keep the original keyWindow to avoid some unpredictable problems
    [currentKeyWindow makeKeyWindow];

}


- (void)hide {
    [self removeFromSuperview];
    _superviewWindow.hidden = YES;
}

#pragma mark - private methods

- (void)keyboardIsShown:(NSNotification *)note {
    
    [self convertSuperViewToKeyboardWindow];
}
- (void)keyboardDidHide {
    
    [self show];
}

#pragma mark -
- (void)convertSuperViewToKeyboardWindow {
    //hide the superViewWindow
    [self hide];
    
    // add superView in keyboardWindow
    self.frame = _currentFrame;
    
    [[self keyboardWindow] addSubview:self];
}

/**
 get the keyboard window
 */
- (UIWindow *)keyboardWindow {
    for(UIWindow* window in [UIApplication sharedApplication].windows)
    {
        if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
        {
            return window;
        }
    }
    return nil;
}


/**
 according to 'UIPanGestureRecognizer' change the super view's position.
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    // windowPoint
    CGPoint panPoint = [pan locationInView:appWindow];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if(pan.state == UIGestureRecognizerStateBegan) {
        // MARK: - UIGestureRecognizerStateBegan  TODO
    }else if(pan.state == UIGestureRecognizerStateChanged) {
        _superviewWindow.center = CGPointMake(panPoint.x, panPoint.y);
        if (_superviewWindow.hidden == YES) {
            self.center = panPoint;
        }
    }else if(pan.state == UIGestureRecognizerStateEnded
             || pan.state == UIGestureRecognizerStateCancelled) {
        
        CGPoint newCenter = panPoint;
        
        if (panPoint.x + self.frame.size.width/2.0 > screenWidth) {
            
            newCenter.x = screenWidth-self.frame.size.width/2.0 - kSuperViewMargin;
        } else if (panPoint.x-self.frame.size.width/2.0 < 0) {
            
            newCenter.x = self.frame.size.width/2.0 + kSuperViewMargin;
        } else if (panPoint.y + self.frame.size.height/2.0> screenHeight) {
            
            newCenter.y = screenHeight - self.frame.size.height/2.0 - kSuperViewMargin;
        } else if (panPoint.y-self.frame.size.height/2.0 < 0) {
            newCenter.y = self.frame.size.height/2.0 + kSuperViewMargin;
            
        }
        
        [UIView animateWithDuration:.25 animations:^{
            _superviewWindow.center = newCenter;
            //
            if (_superviewWindow.hidden == YES) {
                self.center = newCenter;
            }
            
            // record frame for superview back to superviewWindow
            _currentFrame = _superviewWindow.frame;
        }];
    }
}


/**
 super view clicked
 */
- (void)buttonClicked {
    if ([self.delegate respondsToSelector:@selector(superViewClicked:)]) {
        [self.delegate superViewClicked:self];
    }
}

@end
