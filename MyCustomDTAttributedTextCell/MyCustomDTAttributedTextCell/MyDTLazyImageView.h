//
//  MyDTLazyImageView.h
//  JRsapp
//
//  Created by ryan on 16/1/8.
//  Copyright © 2016年 ryan. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@interface MyDTLazyImageView : DTLazyImageView
@property(nonatomic,weak)  DTAttributedTextContentView *textContentView;
@end
