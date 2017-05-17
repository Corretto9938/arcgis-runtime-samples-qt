import QtQuick 2.6
import QtQuick.Controls 1.4

Row {
    //    anchors.horizontalCenter: parent.horizontalCenter

    property alias maxRange : slider.maximumValue
    property alias value: slider.value
    property alias label: text.text
    property alias fontSize: valueLabel.font.pixelSize
    property alias steps: slider.stepSize


    Text {
        id: text
        font.pixelSize: fontSize
        width: 90 * scaleFactor
    }

    Slider {
        id: slider
        width: 185 * scaleFactor
        minimumValue: 0
        maximumValue: maxRange
        stepSize: 1.0

        onValueChanged: {
            if (valueLabel.text !== value)
                valueLabel.text = value;
        }
    }

    Text {
        id: valueLabel
        text: slider.value
    }
}
