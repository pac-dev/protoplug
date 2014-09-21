
pPath Path_new();

void Path_delete(pPath p);


Rectangle_float Path_getBounds(pPath self);

Rectangle_float Path_getBoundsTransformed (pPath self, AffineTransform transform);

bool Path_contains (pPath self, float x, float y,
                   float tolerance);

bool Path_contains2 (pPath self, Point_float point,
                   float tolerance);

bool Path_intersectsLine (pPath self, Line_float line,
                         float tolerance);

Line_float Path_getClippedLine (pPath self, Line_float line, bool keepSectionOutsidePath);

float Path_getLength (pPath self, AffineTransform transform);

Point_float Path_getPointAlongPath (pPath self, float distanceFromStart,
                                    AffineTransform transform);

float Path_getNearestPoint (pPath self, Point_float targetPoint,
                           Point_float &pointOnPath,
                           AffineTransform transform);

void Path_clear(pPath self);

void Path_startNewSubPath (pPath self, float startX, float startY);

void Path_startNewSubPath2 (pPath self, Point_float start);

void Path_closeSubPath(pPath self);

void Path_lineTo (pPath self, float endX, float endY);

void Path_lineTo2 (pPath self, Point_float end);

void Path_quadraticTo (pPath self, float controlPointX,
                      float controlPointY,
                      float endPointX,
                      float endPointY);

void Path_quadraticTo2 (pPath self, Point_float controlPoint,
                      Point_float endPoint);

void Path_cubicTo (pPath self, float controlPoint1X,
                  float controlPoint1Y,
                  float controlPoint2X,
                  float controlPoint2Y,
                  float endPointX,
                  float endPointY);

void Path_cubicTo2 (pPath self, Point_float controlPoint1,
                  Point_float controlPoint2,
                  Point_float endPoint);

Point_float Path_getCurrentPosition(pPath self);

void Path_addRectangle (pPath self, float x, float y, float width, float height);

void Path_addRectangle2 (pPath self, Rectangle_float rectangle);

void Path_addRoundedRectangle2 (pPath self, float x, float y, float width, float height,
                              float cornerSize);

void Path_addRoundedRectangle3 (pPath self, float x, float y, float width, float height,
                              float cornerSizeX,
                              float cornerSizeY);

void Path_addRoundedRectangle4 (pPath self, float x, float y, float width, float height,
                              float cornerSizeX, float cornerSizeY,
                              bool curveTopLeft, bool curveTopRight,
                              bool curveBottomLeft, bool curveBottomRight);

void Path_addRoundedRectangle5 (pPath self, Rectangle_float rectangle, float cornerSizeX, float cornerSizeY);

void Path_addRoundedRectangle6 (pPath self, Rectangle_float rectangle, float cornerSize);

void Path_addTriangle (pPath self, float x1, float y1,
                      float x2, float y2,
                      float x3, float y3);

void Path_addQuadrilateral (pPath self, float x1, float y1,
                           float x2, float y2,
                           float x3, float y3,
                           float x4, float y4);

void Path_addEllipse (pPath self, float x, float y, float width, float height);

void Path_addArc (pPath self, float x, float y, float width, float height,
                 float fromRadians,
                 float toRadians,
                 bool startAsNewSubPath);

void Path_addCentredArc (pPath self, float centreX, float centreY,
                        float radiusX, float radiusY,
                        float rotationOfEllipse,
                        float fromRadians,
                        float toRadians,
                        bool startAsNewSubPath);

void Path_addPieSegment (pPath self, float x, float y,
                        float width, float height,
                        float fromRadians,
                        float toRadians,
                        float innerCircleProportionalSize);

void Path_addLineSegment (pPath self, Line_float line, float lineThickness);

void Path_addArrow (pPath self, Line_float line,
                   float lineThickness,
                   float arrowheadWidth,
                   float arrowheadLength);

void Path_addPolygon (pPath self, Point_float centre,
                     int numberOfSides,
                     float radius,
                     float startAngle);

void Path_addStar (pPath self, Point_float centre,
                  int numberOfPoints,
                  float innerRadius,
                  float outerRadius,
                  float startAngle);

void Path_addBubble (pPath self, Rectangle_float bodyArea,
                    Rectangle_float maximumArea,
                    Point_float arrowTipPosition,
                    const float cornerSize,
                    const float arrowBaseWidth);

void Path_addPath (pPath self, pPath pathToAppend);

void Path_addPath2 (pPath self, pPath pathToAppend,
                  AffineTransform transformToApply);

void Path_applyTransform (pPath self, AffineTransform transform);

void Path_scaleToFit (pPath self, float x, float y, float width, float height,
                     bool preserveProportions);

AffineTransform Path_getTransformToScaleToFit (pPath self, float x, float y, float width, float height,
                                              bool preserveProportions,
                                              int justificationType);

AffineTransform Path_getTransformToScaleToFit2 (pPath self, Rectangle_float area,
                                              bool preserveProportions,
                                              int justificationType);

pPath Path_createPathWithRoundedCorners (pPath self, float cornerRadius);

void Path_setUsingNonZeroWinding (pPath self, bool isNonZeroWinding);

bool Path_isUsingNonZeroWinding(pPath self);

void Path_toString(pPath self, char* dest, int bufSize);

void Path_restoreFromString (pPath self, const char *src);
