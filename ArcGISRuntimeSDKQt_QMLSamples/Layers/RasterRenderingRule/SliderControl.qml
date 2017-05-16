import QtQuick 2.6
import QtQuick.Controls 1.4

Column {
//    anchors.horizontalCenter: parent.horizontalCenter

    property alias maxRange : slider.maximumValue
    property alias value: slider.value
    property alias label: text.text
    property alias fontSize: valueLabel.font.pixelSize
    property alias steps: slider.stepSize

    Row {
        Text {
            id: text
            font.pixelSize: fontSize
        }
    }

    Row {
        Slider {
            id: slider
            width: 100 * scaleFactor
            minimumValue: 0
            maximumValue: maxRange
            stepSize: 1.0

            onValueChanged: {
                if (valueLabel.text !== value)
                    valueLabel.text = value;
            }
        }

        Label {
            id: valueLabel
            text: slider.value
        }
    }
}
