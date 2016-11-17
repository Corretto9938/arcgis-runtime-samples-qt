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

#ifndef SEARCHFORWEBMAPCONTROLLER_H
#define SEARCHFORWEBMAPCONTROLLER_H

namespace Esri
{
    namespace ArcGISRuntime
    {
        class AuthenticationManager;
        class Map;
        class MapQuickView;
        class Portal;
        class PortalItem;
        class PortalItemListModel;
        class PortalQueryResultSetForItems;
    }
}

#include <QObject>

class QAbstractListModel;

class SearchForWebmapController : public QObject
{
    Q_OBJECT

public:
    SearchForWebmapController(QObject* parent = nullptr);
    ~SearchForWebmapController();

    Esri::ArcGISRuntime::AuthenticationManager* authManager() const;
    Esri::ArcGISRuntime::Map *map() const;
    bool portalLoaded() const;
    QAbstractListModel* webmaps() const;
    bool hasMoreResults() const;
    QString mapLoadError() const;

    Q_INVOKABLE void search(const QString keyword);
    Q_INVOKABLE void searchNext();
    Q_INVOKABLE void loadSelectedWebmap(int index);
    Q_INVOKABLE void errorAccepted();

    void init();

signals:
    void authManagerChanged();
    void portalLoadedChanged();
    void webmapsChanged();
    void hasMoreResultsChanged();
    void mapLoaded();
    void mapLoadErrorChanged();

private:
    Esri::ArcGISRuntime::Map* m_map;
    Esri::ArcGISRuntime::Portal* m_portal;
    Esri::ArcGISRuntime::PortalQueryResultSetForItems* m_webmapResults;
    Esri::ArcGISRuntime::PortalItemListModel* m_webmaps;
    Esri::ArcGISRuntime::PortalItem* m_selectedItem;
    bool m_portalLoaded;
    QString m_mapLoadeError;
};

#endif // SEARCHFORWEBMAPCONTROLLER_H
