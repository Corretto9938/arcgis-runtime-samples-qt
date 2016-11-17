// [WriteFile Name=SearchForWebmap, Category=CloudAndPortal]
// [Legal]
// Copyright 2016 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

#ifndef SEARCHFORWEBMAPQUICKITEM_H
#define SEARCHFORWEBMAPQUICKITEM_H

class SearchForWebmapController;

namespace Esri
{
    namespace ArcGISRuntime
    {
        class AuthenticationManager;
        class Map;
        class MapQuickView;
    }
}

#include <QAbstractListModel>
#include <QQuickItem>

class SearchForWebmapQuickItem : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(Esri::ArcGISRuntime::AuthenticationManager* authManager READ authManager NOTIFY authManagerChanged)
    Q_PROPERTY(bool portalLoaded READ portalLoaded NOTIFY portalLoadedChanged)
    Q_PROPERTY(QAbstractListModel* webmaps READ webmaps NOTIFY webmapsChanged)
    Q_PROPERTY(bool hasMoreResults READ hasMoreResults NOTIFY hasMoreResultsChanged)
    Q_PROPERTY(QString mapLoadError READ mapLoadError NOTIFY mapLoadErrorChanged)

public:
    SearchForWebmapQuickItem(QQuickItem* parent = nullptr);
    ~SearchForWebmapQuickItem();

    void componentComplete() Q_DECL_OVERRIDE;

    Esri::ArcGISRuntime::AuthenticationManager* authManager() const;
    bool portalLoaded() const;
    QAbstractListModel* webmaps() const;
    bool hasMoreResults() const;
    QString mapLoadError() const;

    Q_INVOKABLE void search(const QString keyword);
    Q_INVOKABLE void searchNext();
    Q_INVOKABLE void loadSelectedWebmap(int index);
    Q_INVOKABLE void errorAccepted();

signals:
    void authManagerChanged();
    void portalLoadedChanged();
    void webmapsChanged();
    void hasMoreResultsChanged();
    void mapLoadErrorChanged();

private:
    Esri::ArcGISRuntime::MapQuickView* m_mapView;
    SearchForWebmapController* m_controller;
};

#endif // SEARCHFORWEBMAPQUICKITEM_H
