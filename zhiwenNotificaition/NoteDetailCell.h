//
//  NoteDetailCell.h
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteDetailModel;

@interface NoteDetailCell : UITableViewCell

- (void)configWithModel:(NoteDetailModel *)model;

+ (CGFloat)heightForCell:(NoteDetailModel *)model;

@end
