// [WriteFile Name=Web_Tiled_Layer, Category=Layers]
// [Legal]
// Copyright 2017 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

#ifndef WEB_TILED_LAYER_H
#define WEB_TILED_LAYER_H

namespace Esri
{
  namespace ArcGISRuntime
  {
    class Map;
    class MapQuickView;
  }
}

#include <QQuickItem>

class Web_Tiled_Layer : public QQuickItem
{
  Q_OBJECT

public:
  explicit Web_Tiled_Layer(QQuickItem* parent = nullptr);
  ~Web_Tiled_Layer();

  void componentComplete() Q_DECL_OVERRIDE;
  static void init();

private:
  Esri::ArcGISRuntime::Map* m_map = nullptr;
  Esri::ArcGISRuntime::MapQuickView* m_mapView = nullptr;
};

#endif // WEB_TILED_LAYER_H