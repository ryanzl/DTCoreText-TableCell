//
//  MyDTTextCell.m
//  MyCustomDTAttributedTextCell
//
//  Created by ryan on 16/1/9.
//  Copyright © 2016年 ryan. All rights reserved.
//

#import "MyDTTextCell.h"

@implementation MyDTTextCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = CGRectMake(0, 50, self.attributedTextContextView.bounds.size.width, self.attributedTextContextView.bounds.size.height);
    self.attributedTextContextView.frame = frame;
}
@end
