// protojuce/cdefs/graphics.h
// c definitions as exported by protoplug
// included by protojuce.lua


pGraphics Graphics_new(pImage imageToDrawOnto);

void Graphics_delete(pGraphics g);

void Graphics_setColour(pGraphics self, Colour newColour);


void Graphics_setOpacity(pGraphics self, float newOpacity);


void Graphics_setGradientFill(pGraphics self, const pColourGradient gradient);


void Graphics_setTiledImageFill(pGraphics self, const pImage imageToUse,
                            int anchorX, int anchorY,
                            float opacity);


void Graphics_setFillType(pGraphics self, const pFillType newFill);


void Graphics_setFont(pGraphics self, const pFont newFont);


void Graphics_setFont2(pGraphics self, float newFontHeight);


pFont Graphics_getCurrentFont(pGraphics self);


void Graphics_drawSingleLineText(pGraphics self, const char * text,
                             int startX, int baselineY,
                             int justification);


void Graphics_drawMultiLineText(pGraphics self, const char * text,
                            int startX, int baselineY,
                            int maximumLineWidth);


void Graphics_drawText(pGraphics self, const char * text,
                   int x, int y, int width, int height,
                   int justificationType,
                   bool useEllipsesIfTooBig);


void Graphics_drawText2(pGraphics self, const char * text,
                   Rectangle_int area,
                   int justificationType,
                   bool useEllipsesIfTooBig);


void Graphics_drawFittedText(pGraphics self, const char * text,
                         int x, int y, int width, int height,
                         int justificationFlags,
                         int maximumNumberOfLines,
                         float minimumHorizontalScale /* = 0.7f */);


void Graphics_drawFittedText2(pGraphics self, const char * text,
                         Rectangle_int area,
                         int justificationFlags,
                         int maximumNumberOfLines,
                         float minimumHorizontalScale/*  = 0.7f */);


void Graphics_fillAll(pGraphics self);


void Graphics_fillAll2(pGraphics self, Colour colourToUse);


void Graphics_fillRect(pGraphics self, Rectangle_int rectangle);


void Graphics_fillRect2(pGraphics self, Rectangle_float rectangle);


void Graphics_fillRect3(pGraphics self, int x, int y, int width, int height);


void Graphics_fillRect4(pGraphics self, float x, float y, float width, float height);


void Graphics_fillRoundedRectangle(pGraphics self, float x, float y, float width, float height,
                               float cornerSize);


void Graphics_fillRoundedRectangle2(pGraphics self, Rectangle_float rectangle,
                               float cornerSize);


void Graphics_fillCheckerBoard(pGraphics self, Rectangle_int area,
                           int checkWidth, int checkHeight,
                           Colour colour1, Colour colour2);


void Graphics_drawRect(pGraphics self, int x, int y, int width, int height, int lineThickness /* = 1 */);


void Graphics_drawRect2(pGraphics self, float x, float y, float width, float height, float lineThickness/*  = 1.0f */);


void Graphics_drawRect3(pGraphics self, Rectangle_int rectangle, int lineThickness /* = 1 */);


void Graphics_drawRect4(pGraphics self, Rectangle_float rectangle, float lineThickness /* = 1.0f */);


void Graphics_drawRoundedRectangle(pGraphics self, float x, float y, float width, float height,
                               float cornerSize, float lineThickness);


void Graphics_drawRoundedRectangle2(pGraphics self, Rectangle_float rectangle,
                               float cornerSize, float lineThickness);


void Graphics_setPixel(pGraphics self, int x, int y);


void Graphics_fillEllipse(pGraphics self, float x, float y, float width, float height);


void Graphics_fillEllipse2(pGraphics self, Rectangle_float area);


void Graphics_drawEllipse(pGraphics self, float x, float y, float width, float height,
                      float lineThickness);


void Graphics_drawLine(pGraphics self, float startX, float startY, float endX, float endY);


void Graphics_drawLine2(pGraphics self, float startX, float startY, float endX, float endY, float lineThickness);


void Graphics_drawLine3(pGraphics self, Line_float line);


void Graphics_drawLine4(pGraphics self, Line_float line, float lineThickness);


void Graphics_drawDashedLine(pGraphics self, Line_float line,
                         const float* dashLengths, int numDashLengths,
                         float lineThickness /* = 1.0f */,
                         int dashIndexToStartFrom /* = 0 */);


void Graphics_drawVerticalLine(pGraphics self, int x, float top, float bottom);


void Graphics_drawHorizontalLine(pGraphics self, int y, float left, float right);


void Graphics_fillPath(pGraphics self, pPath path,
                   AffineTransform transform);


void Graphics_strokePath(pGraphics self, pPath path,
                     PathStrokeType strokeType,
                     AffineTransform transform);


void Graphics_drawArrow(pGraphics self, Line_float line,
                    float lineThickness,
                    float arrowheadWidth,
                    float arrowheadLength);


void Graphics_setImageResamplingQuality(pGraphics self, const int newQuality);


void Graphics_drawImageAt(pGraphics self, pImage imageToDraw, int topLeftX, int topLeftY,
                      bool fillAlphaChannelWithCurrentBrush /* = false */);


void Graphics_drawImage(pGraphics self, pImage imageToDraw,
                    int destX, int destY, int destWidth, int destHeight,
                    int sourceX, int sourceY, int sourceWidth, int sourceHeight,
                    bool fillAlphaChannelWithCurrentBrush /* = false */);


void Graphics_drawImageTransformed(pGraphics self, pImage imageToDraw,
                               AffineTransform transform,
                               bool fillAlphaChannelWithCurrentBrush /* = false */);


void Graphics_drawImageWithin(pGraphics self, pImage imageToDraw,
                          int destX, int destY, int destWidth, int destHeight,
                          int placementWithinTarget,
                          bool fillAlphaChannelWithCurrentBrush /* = false */);


Rectangle_int Graphics_getClipBounds(pGraphics self);


bool Graphics_clipRegionIntersects(pGraphics self, Rectangle_int area);


bool Graphics_reduceClipRegion(pGraphics self, int x, int y, int width, int height);


bool Graphics_reduceClipRegion2(pGraphics self, Rectangle_int area);


bool Graphics_reduceClipRegion4(pGraphics self, pPath path, AffineTransform transform);


bool Graphics_reduceClipRegion5(pGraphics self, pImage image, AffineTransform transform);


void Graphics_excludeClipRegion(pGraphics self, Rectangle_int rectangleToExclude);


bool Graphics_isClipEmpty(pGraphics self);


void Graphics_saveState(pGraphics self);


void Graphics_restoreState(pGraphics self);


void Graphics_beginTransparencyLayer(pGraphics self, float layerOpacity);


void Graphics_endTransparencyLayer(pGraphics self);


void Graphics_setOrigin(pGraphics self, Point_int newOrigin);


void Graphics_setOrigin2(pGraphics self, int newOriginX, int newOriginY);


void Graphics_addTransform(pGraphics self, AffineTransform transform);


void Graphics_resetToDefaultState(pGraphics self);


bool Graphics_isVectorDevice(pGraphics self);