//
//  WBFPSLabel.m
//  Weiboad
//
//  Created by penghui8 on 2018/4/27.
//  Copyright © 2018年 Only·io All rights reserved.
//

#import "WBFPSLabel.h"
#import <CoreText/CoreText.h>

#define wbSize CGSizeMake(55.0f, 20.0f)

static NSInteger const wbFPSLabelTag = 999;

@interface WBFPSLabel ()
{
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
}

@end

@implementation WBFPSLabel

+ (void)wb_showFPSInView:(UIView *)view frame:(CGRect)frame {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    WBFPSLabel *fpsLabel = [view viewWithTag:wbFPSLabelTag];
    if (!fpsLabel) {
        fpsLabel = [[WBFPSLabel alloc] initWithFrame:frame];
    }
    else {
        fpsLabel.frame = frame;
    }
    
    if([fpsLabel isDescendantOfView:view]) {
        [fpsLabel removeFromSuperview];
    }
    
    [view addSubview:fpsLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0.0f && frame.size.height == 0.0f) {
        frame.size = wbSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.textColor = [UIColor redColor];
    
    _font = [UIFont fontWithName:@"Menlo" size:14.0f];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4.0f];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14.0f];
        _subFont = [UIFont fontWithName:@"Courier" size:4.0f];
    }
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return wbSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0f;
    UIColor *color = [UIColor colorWithHue:0.27f * (progress - 0.2f) saturation:1.0f brightness:0.9f alpha:1.0f];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    
    [text addAttribute:(NSString *)kCTForegroundColorAttributeName
                 value:(id)color.CGColor
                 range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:(NSString *)kCTForegroundColorAttributeName
                 value:(id)[UIColor whiteColor].CGColor
                 range:NSMakeRange(text.length - 3, 3)];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize, nil);
    if (nil != fontRef)
    {
        [text addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, text.length)];
        CFRelease(fontRef);
    }
    
    fontRef = CTFontCreateWithName((CFStringRef)_subFont.fontName, _subFont.pointSize, nil);
    if (nil != fontRef)
    {
        [text addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(text.length - 4, 1)];
        CFRelease(fontRef);
    }
    
    self.attributedText = text;
}

@end
