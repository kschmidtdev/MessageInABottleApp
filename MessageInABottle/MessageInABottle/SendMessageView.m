//
//  SendMessageView.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "SendMessageView.h"

@implementation SendMessageView
@synthesize messageTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    
    if ([messageTextView isFirstResponder] && [touch view] != messageTextView)
    {
        [messageTextView resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
