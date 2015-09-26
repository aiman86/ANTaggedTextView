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
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self.attributedString enumerateAttributesInRange:(NSRange){0, self.string.length} options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         if ([attributes objectForKey:@"Tag"] != nil)
         {
             NSDictionary* tagAttributes = [self.attributedString attributesAtIndex:range.location effectiveRange:nil];
             NSSize oneCharSize = [@"a" sizeWithAttributes:tagAttributes];
             NSRange activeRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
             NSRect tagRect = [self.layoutManager boundingRectForGlyphRange:activeRange inTextContainer:self.textContainer];
             tagRect.origin.x += self.textContainerOrigin.x;
             tagRect.origin.y += self.textContainerOrigin.y;
             tagRect = [self convertRectToLayer:tagRect];
             NSRect tagBorderRect = (NSRect){ (NSPoint){tagRect.origin.x-oneCharSize.width*0.25, tagRect.origin.y+1}, (NSSize){tagRect.size.width+oneCharSize.width*0.33, tagRect.size.height} };
             
             [NSGraphicsContext saveGraphicsState];
             NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:tagBorderRect xRadius:3.0f yRadius:3.0f];
             NSColor* fillColor = [NSColor colorWithCalibratedRed:237.0/255.0 green:243.0/255.0 blue:252.0/255.0 alpha:1];
             NSColor* strokeColor = [NSColor colorWithCalibratedRed:163.0/255.0 green:188.0/255.0 blue:234.0/255.0 alpha:1];             
             NSColor* textColor = [NSColor colorWithCalibratedRed:37.0/255.0 green:62.0/255.0 blue:112.0/255.0 alpha:1];
             
             [path addClip];
             [fillColor setFill];
             [strokeColor setStroke];
             NSRectFillUsingOperation(tagBorderRect, NSCompositeSourceOver);
             NSAffineTransform *transform = [NSAffineTransform transform];
             [transform translateXBy: 0.5 yBy: 0.5];
             [path transformUsingAffineTransform: transform];
             [path stroke];
             [transform translateXBy: -1.5 yBy: -1.5];
             [path transformUsingAffineTransform: transform];
             [path stroke];
             
             NSMutableDictionary* attrs = [NSMutableDictionary dictionaryWithDictionary:tagAttributes];
             NSFont* font = [tagAttributes valueForKey:NSFontAttributeName];
             font = [[NSFontManager sharedFontManager] convertFont:font toSize:[font pointSize] - 0.25];
             [attrs addEntriesFromDictionary:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}];
             [[self.attributedString.string substringWithRange:range] drawInRect:tagRect withAttributes:attrs];

             [NSGraphicsContext restoreGraphicsState];
         }
     }];
}
@end
