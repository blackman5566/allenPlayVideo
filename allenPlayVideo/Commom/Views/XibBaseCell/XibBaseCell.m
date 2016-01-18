//
//  XibBaseCell.m
//  allenPlayVideo
//
//  Created by daisuke on 2016/1/18.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "XibBaseCell.h"

@implementation XibBaseCell

#pragma mark - life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
    }
    return self;
}

@end
