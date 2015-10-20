// Copyright 2015 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import QtQuick 2.3
import Esri.ArcGISRuntime 100.00
import Esri.ArcGISExtras 1.1

Rectangle {
    width: 800
    height: 600

    property real scaleFactor: System.displayScaleFactor

    MapView {
        anchors.fill: parent
        Map {
            id: map
            // Specify the SpatialReference
            spatialReference: SpatialReference { wkid:54024 }

            onComponentCompleted: {
               //Add the basemap to the map
               map.basemap = ArcGISRuntimeEnvironment.createObject("Basemap", { "json": {"uri":"http://sampleserver6.arcgisonline.com/arcgis/rest/services/SampleWorldCities/MapServer"}});
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border {
            width: 0.5 * scaleFactor
            color: "black"
        }
    }
}