// [WriteFile Name=RasterRenderingRule, Category=Layers]
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

import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.1
import Esri.ArcGISExtras 1.1

Rectangle {
    id: rootRectangle
    clip: true

    width: 800
    height: 600

    property double scaleFactor: System.displayScaleFactor
    property var renderingRuleNames: []
    property url imageServiceUrl: "http://utility.arcgis.com/usrsvcs/servers/e202a8f394a04629979367e96d80422b/rest/services/WorldElevation/Terrain/ImageServer"//"https://sampleserver6.arcgisonline.com/arcgis/rest/services/CharlotteLAS/ImageServer"
    property RasterLayer rasterLayer: null
    property ImageServiceRaster isr: null

    MapView {
        anchors.fill: parent
        id: mapView

        Map {
            id: map
            // create a basemap from a tiled layer and add to the map
            BasemapStreets {}

//            // create and add a raster layer to the map
//            RasterLayer {
//                // create the raster layer from an image service raster
//                ImageServiceRaster {
//                    id: imageServiceRaster
//                    url: imageServiceUrl

//                    // zoom to the extent of the raster once it's loaded
//                    onLoadStatusChanged: {
//                        if (loadStatus === Enums.LoadStatusLoaded) {
//                            mapView.setViewpointGeometry(imageServiceRaster.serviceInfo.fullExtent);

//                            var renderingRuleInfos = imageServiceRaster.serviceInfo.renderingRuleInfos;
//                            var names = [];
//                            for (var i = 0; i < renderingRuleInfos.length; i++) {
//                                names.push(renderingRuleInfos[i].name);
//                            }
//                            renderingRuleNames = names;
//                        }
//                    }
//                }

//                onComponentCompleted: {
//                    rasterLayer = this;
//                }
//            }
        }

        MinMaxStretchParameters {
            id: minMaxParams
        }

        PercentClipStretchParameters {
            id: percentClipParams
        }

        StandardDeviationStretchParameters {
            id: standardDeviationParams
        }

        Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                margins: 5 * scaleFactor
            }
            height: 250 * scaleFactor
            width: 300 * scaleFactor
            color: "silver"
            radius: 5 * scaleFactor

            Column {
                spacing: 10 * scaleFactor
                anchors {
                    fill: parent
                    margins: 5 * scaleFactor
                }

                Label {
                    text: "Select an ImageService"
                    font.pixelSize: 16 * scaleFactor
                }
                Row {
                    ComboBox {
                        id: isrCombo
                        width: 130 * scaleFactor
                        model: [
                            "https://rdvmtest01.esri.com/server/rest/services/southafrica/ImageServer",
                            "http://sampleserver6.arcgisonline.com/arcgis/rest/services/NLCDLandCover2001/ImageServer",
                            "http://sampleserver6.arcgisonline.com/arcgis/rest/services/Toronto/ImageServer",
                            "http://clear3.uconn.edu/arcgis/rest/services/Aerials/CTCoast1934/ImageServer",
                            "https://landsat2.arcgis.com/arcgis/rest/services/Landsat8_Views/ImageServer",
                            "http://holistic30.esri.com:6080/arcgis/rest/services/elevation/ImageServer",
                            "https://imagery.gis.in.gov/arcgis/rest/services/Imagery/2011_2013_Imagery/ImageServer",
                            "http://imagery.arcgisonline.com/arcgis/rest/services/LandsatGLSChange/NDVI_Change_2005_2010/ImageServer",
                            "http://utility.arcgis.com/usrsvcs/servers/e202a8f394a04629979367e96d80422b/rest/services/WorldElevation/Terrain/ImageServer"
                        ]
                    }

                    Button {
                        text: "Go"
                        onClicked: {
                            isr = ArcGISRuntimeEnvironment.createObject("ImageServiceRaster", {url: isrCombo.currentText});
                            isr.loadStatusChanged.connect(function(){
                                if (isr.loadStatus === Enums.LoadStatusLoaded) {
                                    mapView.setViewpointGeometry(isr.serviceInfo.fullExtent);

                                    var renderingRuleInfos = isr.serviceInfo.renderingRuleInfos;
                                    var names = [];
                                    for (var i = 0; i < isr.serviceInfo.renderingRuleInfos.length; i++) {
                                        names.push(isr.serviceInfo.renderingRuleInfos[i].name);
                                    }
                                    renderingRuleNames = names;
                                }
                            });

                            rasterLayer = ArcGISRuntimeEnvironment.createObject("RasterLayer", {raster: isr});
                            mapView.map.operationalLayers.append(rasterLayer);
                        }
                    }
                }

                Label {
                    text: "Apply a Rendering Rule"
                    font.pixelSize: 16 * scaleFactor
                }

                Row {
                    spacing: 5 * scaleFactor

                    ComboBox {
                        id: renderingRulesCombo
                        width: 130 * scaleFactor
                        model: renderingRuleNames
                    }

                    Button {
                        id: applyButton
                        text: "Apply"
                        width: 50 * scaleFactor
                        onClicked: {
                            applyRenderingRule(renderingRulesCombo.currentIndex);
                        }
                    }
                }

                Label {
                    text: "Apply Stretch Renderer"
                    font.pixelSize: 16 * scaleFactor
                }

                Row {
                    Label {
                        text: "Stretch type: "
                        font.pixelSize: 14 * scaleFactor
                    }

                    ComboBox {
                        id: stretchParamType
                        width: 130 * scaleFactor
                        model: ["MinMax", "PercentClip", "StandardDeviation"]
                    }
                }

                SliderControl {
                    id: gamma
                    visible: stretchParamType.currentText === "MinMax"
                    spacing: 8 * scaleFactor
                    label: "Gamma"
                    maxRange: 10.0
                    value: 2.0
                    steps: 0.1
                    fontSize: 14 * scaleFactor
                }

//                SliderControl {
//                    id: percentClipMin
//                    visible: stretchParamType.currentText === "PercentClip"
//                    spacing: 8 * scaleFactor
//                    label: "Min Value"
//                    maxRange: 255
//                    value: 0
//                    fontSize: 14 * scaleFactor
//                }

//                SliderControl {
//                    id: percentClipMax
//                    visible: stretchParamType.currentText === "PercentClip"
//                    spacing: 8 * scaleFactor
//                    label: "Max Value"
//                    maxRange: 255
//                    value: 255
//                    fontSize: 14 * scaleFactor
//                }

//                SliderControl {
//                    id: sd
//                    visible: stretchParamType.currentText === "StandardDeviation"
//                    spacing: 8 * scaleFactor
//                    label: "Factor"
//                    maxRange: 25
//                    value: 0
//                    steps: 0.5
//                    fontSize: 14 * scaleFactor
//                }

                Button {
                    text: "Apply"
                    onClicked: {
                        var renderer = ArcGISRuntimeEnvironment.createObject("StretchRenderer");
                        //                        renderer.gammasChanged.connect(function(){
                        //                            console.log("Gamma changed");
                        //                        });
                        renderer.gammas = [gamma.value];

                        var currentText = stretchParamType.currentText;
                        if (currentText === "MinMax") {
                            minMaxParams.minValues = [100];
                            minMaxParams.maxValues = [500];
                            renderer.stretchParameters = minMaxParams;
                        }
                        else if(currentText === "PercentClip") {
                            percentClipParams.min = percentClipMin.value;
                            percentClipParams.max = 100 - percentClipMax.value;
                            renderer.stretchParameters = percentClipParams;
                        }
                        else {
                            standardDeviationParams.factor = sd.value;
                            renderer.stretchParameters = standardDeviationParams;
                        }

                        if (rasterLayer) {
                            rasterLayer.renderer = renderer;
                        }
                    }
                }
            }
        }
    }

    function applyRenderingRule(index) {
        // get the rendering rule info at the selected index
        var renderingRuleInfo = isr.serviceInfo.renderingRuleInfos[index];
        // create a rendering rule object using the rendering rule info
        var renderingRule = ArcGISRuntimeEnvironment.createObject("RenderingRule", {renderingRuleInfo: renderingRuleInfo});
        // create a new image service raster
        var newImageServiceRaster = ArcGISRuntimeEnvironment.createObject("ImageServiceRaster", {url: imageServiceUrl});
        // apply the rendering rule
        newImageServiceRaster.renderingRule = renderingRule;

        rasterLayer = null;
        // create a raster layer using the image service raster
        rasterLayer = ArcGISRuntimeEnvironment.createObject("RasterLayer", {raster: newImageServiceRaster});
//        map.operationalLayers.clear();
        // add the raster layer to the map
        map.operationalLayers.append(rasterLayer);
    }
}
