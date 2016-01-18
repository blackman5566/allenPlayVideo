//
//  UITableViewCell+Category.m
//  allenPlayVideo
//
//  Created by daisuke on 2016/1/18.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Category)

- (NSIndexPath *)indexPath {
    return [[self dependTableView] indexPathForCell:self];
}

#pragma mark - private instance method

- (UITableView *)dependTableView {
    UIView *findView = self.superview;
    while (![findView isKindOfClass:[UITableView class]]) {
        findView = findView.superview;
    }
    UITableView *table = (UITableView *)findView;
    return table;
}

@end
