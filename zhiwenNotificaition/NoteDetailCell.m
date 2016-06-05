//
//  NoteDetailCell.m
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import "NoteDetailCell.h"
#import "NoteDetailModel.h"

@interface NoteDetailCell ()

@property (nonatomic, strong) UILabel * noteLabel;

@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation NoteDetailCell

+ (CGFloat)heightForCell:(NoteDetailModel *)model{
    
    CGFloat height = 0;
    
    //顶部的高度
    height = height + 5;
    
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:13.f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    height = height + size.height;
    
    //内容距离时间间距
    
    height = height + 5;
    
    //时间高度
    
    height = height + 30;
    
    return height;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    self.noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 0)];
    self.noteLabel.font = [UIFont systemFontOfSize:13.f];
    self.noteLabel.textColor = [UIColor blackColor];
    self.noteLabel.numberOfLines = 0;
    [self addSubview:self.noteLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 0, 120, 30)];
    self.timeLabel.font = [UIFont systemFontOfSize:11.f];
    self.timeLabel.textColor = [UIColor blackColor];
    [self addSubview:self.timeLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)configWithModel:(NoteDetailModel *)model{

    self.noteLabel.text = model.content;
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:13.f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rectC = self.noteLabel.frame;
    rectC.size = size;
    self.noteLabel.frame = rectC;
    
    self.timeLabel.text = model.time;
    
    CGRect rect = self.timeLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.noteLabel.frame) + 5;
    self.timeLabel.frame = rect;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
