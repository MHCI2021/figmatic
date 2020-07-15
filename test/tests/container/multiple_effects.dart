Map<String, dynamic> data={
  "id": "7:13",
  "name": "multiple effects",
  "type": "RECTANGLE",
  "blendMode": "PASS_THROUGH",
  "absoluteBoundingBox": {
    "x": -430,
    "y": 125,
    "width": 425,
    "height": 77
  },
  "constraints": {
    "vertical": "TOP",
    "horizontal": "LEFT"
  },
  "relativeTransform": [
    [
      1,
      0,
      30
    ],
    [
      0,
      1,
      506
    ]
  ],
  "size": {
    "x": 425,
    "y": 77
  },
  "fills": [
    {
      "blendMode": "NORMAL",
      "type": "SOLID",
      "color": {
        "r": 0.7686274647712708,
        "g": 0.7686274647712708,
        "b": 0.7686274647712708,
        "a": 1
      }
    }
  ],
  "fillGeometry": [
    {
      "path": "M0 0L425 0L425 77L0 77L0 0Z",
      "windingRule": "NONZERO"
    }
  ],
  "strokes": [
    {
      "blendMode": "NORMAL",
      "type": "SOLID",
      "color": {
        "r": 0,
        "g": 0,
        "b": 0,
        "a": 1
      }
    }
  ],
  "strokeWeight": 3,
  "strokeAlign": "INSIDE",
  "strokeGeometry": [
    {
      "path": '''M0 0L0 -3L-3 -3L-3 0L0 0ZM425 0L428 0L428 -3L425 -3L425 0ZM425 77L425 80L428
      80L428 77L425 77ZM0 77L-3 77L-3 80L0 80L0 77ZM0 3L425 3L425 -3L0 -3L0 3ZM422 0L422
      77L428 77L428 0L422 0ZM425 74L0 74L0 80L425 80L425 74ZM3 77L3 0L-3 0L-3 77L3 77Z''',
      "windingRule": "NONZERO"
    }
  ],
  "effects": [
    {
      "type": "LAYER_BLUR",
      "visible": true,
      "radius": 4
    },
    {
      "type": "DROP_SHADOW",
      "visible": true,
      "color": {
        "r": 0,
        "g": 0,
        "b": 0,
        "a": 0.25
      },
      "blendMode": "NORMAL",
      "offset": {
        "x": 0,
        "y": 4
      },
      "radius": 4
    }
  ]
};
