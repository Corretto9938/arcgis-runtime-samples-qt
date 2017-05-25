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
    id: demo
    clip: true

    width: 800
    height: 600

    property double scaleFactor: System.displayScaleFactor
    property bool sideBarVisible : false
    property real sidebarWidth : 0.25
    property var renderingRuleNames: []
    property url imageServiceUrl: "http://utility.arcgis.com/usrsvcs/servers/e202a8f394a04629979367e96d80422b/rest/services/WorldElevation/Terrain/ImageServer"//"https://sampleserver6.arcgisonline.com/arcgis/rest/services/CharlotteLAS/ImageServer"
    property RasterLayer rasterLayer: null
    property ImageServiceRaster isr: null

    ListModel {
        id: isrModel
//        ListElement {
//         name: "South Africa"
//         url: "https://rdvmtest01.esri.com/server/rest/services/southafrica/ImageServer"
//         user: "admin"
//         pwd: "adminadmin"
//        }
        ListElement {
            name: "Land Cover"
            url: "http://sampleserver6.arcgisonline.com/arcgis/rest/services/NLCDLandCover2001/ImageServer"
        }
        ListElement {
            name: "4 band Satellite Imagery Toronto"
            url: "http://sampleserver6.arcgisonline.com/arcgis/rest/services/Toronto/ImageServer"
        }
        ListElement {
            name: "CT Aerial Photographs"
            url: "http://clear3.uconn.edu/arcgis/rest/services/Aerials/CTCoast1934/ImageServer"
        }
        ListElement {
            name: "8 band multispectral"
            url: "https://landsat2.arcgis.com/arcgis/rest/services/Landsat8_Views/ImageServer"
        }
        ListElement {
            name: "IN Orthos"
            url: "https://imagery.gis.in.gov/arcgis/rest/services/Imagery/2011_2013_Imagery/ImageServer"
        }
        ListElement {
            name: "NDVI"
            url: "http://imagery.arcgisonline.com/arcgis/rest/services/LandsatGLSChange/NDVI_Change_2005_2010/ImageServer"
        }
        ListElement {
            name: "World Elevation"
            url: "http://utility.arcgis.com/usrsvcs/servers/e202a8f394a04629979367e96d80422b/rest/services/WorldElevation/Terrain/ImageServer"
        }
    }

    Rectangle {
        id: sidebar
        anchors {
            left: parent.left
            top: titleBar.bottom
            right: parent.right
            bottom: parent.bottom
        }
        visible: true
        //width: Qt.platform.os === "ios" || Qt.platform.os === "android" ? 250 * scaleFactor : 350 * scaleFactor
        color: "#FBFBFB"

        Rectangle {
            id: optionsRect
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10 * scaleFactor
            }
            height: 100 * scaleFactor
            radius: 5 * scaleFactor
            color: "lightgrey"

            Column {
                spacing: 10 * scaleFactor
                anchors.fill: parent
                anchors.margins: 10 * scaleFactor

                Text {
                    text: qsTr("Select an ImageService")
                    font.pixelSize: 20 * scaleFactor
                }

                Row {
                    spacing: 10 * scaleFactor

                    ComboBox {
                        id: isrCombo
                        width: 200 * scaleFactor
                        model: isrModel
                        textRole: "name"
                    }

                    Button {
                        text: "Go"
                        onClicked: {
                            var credential = ArcGISRuntimeEnvironment.createObject("Credential", {usename: isrModel.get(isrCombo.currentIndex).user, password: isrModel.get(isrCombo.currentIndex).pwd})
                            isr = ArcGISRuntimeEnvironment.createObject("ImageServiceRaster", {url: isrModel.get(isrCombo.currentIndex).url, credential: credential});
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
                            mapView.map.operationalLayers.clear();
                            mapView.map.operationalLayers.append(rasterLayer);
                        }
                    }
                }
            }
        }

        Rectangle {
            id: renderingRulesRect
            anchors {
                top: optionsRect.bottom
                left: parent.left
                right: parent.right
                margins: 10 * scaleFactor
            }
            height: 100 * scaleFactor
            radius: 5 * scaleFactor

            Column {
                spacing: 10 * scaleFactor
                anchors.fill: parent
                anchors.margins: 10 * scaleFactor
                Text {
                    text: qsTr("Rendering Rule")
                    font.pixelSize: 20 * scaleFactor
                }

                Row {
                    spacing: 10 * scaleFactor

                    ComboBox {
                        id: renderingRulesCombo
                        width: 200 * scaleFactor
                        model: renderingRuleNames
                    }

                    Button {
                        id: applyButton
                        text: "Apply"
                        onClicked: {
                            applyRenderingRule(renderingRulesCombo.currentIndex);
                        }
                    }
                }

            }
        }

        Rectangle {
            id: rendererRect
            anchors {
                top: renderingRulesRect.bottom
                left: parent.left
                right: parent.right
                margins: 10 * scaleFactor
            }
            height: 100 * scaleFactor
            radius: 5 * scaleFactor

            Column {
                spacing: 10 * scaleFactor
                anchors.fill: parent
                anchors.margins: 10 * scaleFactor
                Text {
                    text: qsTr("Stretch Renderer")
                    font.pixelSize: 20 * scaleFactor
                }

                Row {
                    spacing: 10 * scaleFactor

                    Text {
                        text: "Stretch type: "
                        font.pixelSize: 14 * scaleFactor
                    }

                    ComboBox {
                        id: stretchParamType
                        width: 200 * scaleFactor
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

                Button {
                    text: "Apply"
                    anchors.left: parent.left
                    anchors.leftMargin: 220 * scaleFactor
//                    width: 300 * scaleFactor
                    onClicked: {
                        var renderer = ArcGISRuntimeEnvironment.createObject("StretchRenderer");
                        renderer.gammas = [gamma.value];

                        var currentText = stretchParamType.currentText;
                        if (currentText === "MinMax") {
//                            minMaxParams.minValues = [100];
//                            minMaxParams.maxValues = [500];
//                            renderer.stretchParameters = minMaxParams;
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

        //***************** Title bar ************************************************
        Rectangle {
            id: titleBar
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: 50
            color: "#005d9a"

            Image {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: 40
                height: 50
                source: "qrc:///images/hamburger_icon.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        showMenu();
                    }
                }
            }

            Text {
                text: "Image Service Raster Demo"
                anchors.centerIn: parent
                color: "white"
                font {
                    family: "sanserif"
                    pixelSize: 30
                }
            }
        }
        //***************** Title bar end************************************************


        MapView {
            id: mapView
            anchors {
                left: parent.left
                top: titleBar.bottom
                bottom: parent.bottom
                right: parent.right
            }
//            wrapAroundMode: Enums.WrapAroundModeDisabled

            Map {
                id: map
                // create a basemap from a tiled layer and add to the map
                BasemapStreets {}
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

            transform: Translate {
                id: translate
                x: 0
                Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad }}
            }

            Button {
                anchors.left: parent.left
                text: "Click"

                onClicked: {
                    console.log(JSON.stringify(isr.serviceInfo.fullExtent.json));
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

        // function to control the showing and hiding of the sidebar
        function showMenu() {
            translate.x = sideBarVisible ? 0 : demo.width * sidebarWidth;
            sideBarVisible = !sideBarVisible;
        }
    }
