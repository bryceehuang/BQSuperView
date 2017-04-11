//
//  BQSuperView.h
//  BQSuperViewDemo
//
//  Created by huangbq on 2017/4/4.
//  Copyright © 2017年 huangbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQSuperViewWindow : UIWindow
@end

@interface BQSuperViewController : UIViewController
@end

@class BQSuperView;
@protocol BQSuperViewDelegate <NSObject>
/**
 call back when superView clicked
 */
- (void)superViewClicked:(BQSuperView *)superView;

@end


@interface BQSuperView : UIButton

@property (nonatomic, weak) id<BQSuperViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BQSuperViewDelegate>)delegate;

/**
 *  show
 */
- (void)show;

/**
 *  hide
 */
- (void)hide;

@end
