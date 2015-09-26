// The MIT License (MIT)
//
// Copyright (c) 2015 Aiman Najjar (aimannajjar.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "ANTaggedTextView.h"

@implementation ANTaggedTextView


- (ANTaggedTextView*)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.textContainerInset = (NSSize){0,0};
        self.textContainer.lineFragmentPadding = 0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self.attributedString enumerateAttributesInRange:(NSRange){0, self.string.length} options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         if ([attributes objectForKey:@"Tag"] != nil)
         {
             NSRect rect = [self frame];
             rect = NSInsetRect(rect, self.textContainer.lineFragmentPadding, -1.0f);

             NSDictionary* tagAttributes = [self.attributedString attributesAtIndex:range.location effectiveRange:nil];
             NSPoint point = [self.textContainer.layoutManager locationForGlyphAtIndex:range.location];

             
             [NSGraphicsContext saveGraphicsState];
             NSSize size = (NSSize) [[self.string substringWithRange:range] sizeWithAttributes: [self.attributedString fontAttributesInRange:(NSRange){range.location, range.length}]];
             point.y = rect.origin.y;
             
             NSRect attributedRect = (NSRect){point, size};
             
             NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:attributedRect xRadius:5.0f yRadius:5.0f];
             NSColor* strokeColor = [NSColor colorWithCalibratedRed:163.0/255.0 green:188.0/255.0 blue:234.0/255.0 alpha:1];
             NSColor* fillColor = [NSColor colorWithCalibratedRed:217.0/255.0 green:228.0/255.0 blue:247.0/255.0 alpha:1];
             NSColor* textColor = [NSColor colorWithCalibratedRed:37.0/255.0 green:62.0/255.0 blue:112.0/255.0 alpha:1];
             
             [path addClip];
             [fillColor setFill];
             [strokeColor setStroke];
             NSRectFillUsingOperation(attributedRect, NSCompositeSourceOver);
             NSAffineTransform *transform = [NSAffineTransform transform];
             [transform translateXBy: 0.5 yBy: 0.5];
             [path transformUsingAffineTransform: transform];
             [path stroke];
             [transform translateXBy: -1 yBy: -1];
             [path transformUsingAffineTransform: transform];
             [path stroke];
             
             NSMutableDictionary* attrs = [NSMutableDictionary dictionaryWithDictionary:tagAttributes];
             [attrs addEntriesFromDictionary:@{NSForegroundColorAttributeName: textColor}];
             [[self.attributedString.string substringWithRange:range] drawAtPoint:point withAttributes: attrs];
             
             
             [NSGraphicsContext restoreGraphicsState];
         }
     }];
}

@end
