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

#include "Map.h"
#include "MapQuickView.h"
#include "SearchForWebmapQuickItem.h"
#include "SearchForWebmapController.h"

using namespace Esri::ArcGISRuntime;

SearchForWebmapQuickItem::SearchForWebmapQuickItem(QQuickItem* parent /* = nullptr */):
    QQuickItem(parent),
    m_mapView(nullptr),
    m_controller(new SearchForWebmapController(this))
{
    connect(m_controller, &SearchForWebmapController::portalLoadedChanged, this, &SearchForWebmapQuickItem::portalLoadedChanged);
    connect(m_controller, &SearchForWebmapController::webmapsChanged, this, &SearchForWebmapQuickItem::webmapsChanged);
    connect(m_controller, &SearchForWebmapController::hasMoreResultsChanged, this, &SearchForWebmapQuickItem::hasMoreResultsChanged);
    connect(m_controller, &SearchForWebmapController::mapLoadErrorChanged, this, &SearchForWebmapQuickItem::mapLoadErrorChanged);
    connect(m_controller, &SearchForWebmapController::authManagerChanged, this, &SearchForWebmapQuickItem::authManagerChanged);
    connect(m_controller, &SearchForWebmapController::mapLoaded, this, [this](){
        if (!m_mapView)
            return;

        m_mapView->setMap(m_controller->map());
        m_mapView->setVisible(true);
    });
}

SearchForWebmapQuickItem::~SearchForWebmapQuickItem()
{
}

void SearchForWebmapQuickItem::componentComplete()
{
    QQuickItem::componentComplete();
    m_controller->init();

    // find QML MapView component
    m_mapView = findChild<MapQuickView*>("mapView");
    m_mapView->setWrapAroundMode(WrapAroundMode::Disabled);
}

bool SearchForWebmapQuickItem::portalLoaded() const
{
    return m_controller->portalLoaded();
}

QAbstractListModel* SearchForWebmapQuickItem::webmaps() const
{
    return m_controller->webmaps();
}

bool SearchForWebmapQuickItem::hasMoreResults() const
{
    return m_controller->hasMoreResults();
}

QString SearchForWebmapQuickItem::mapLoadError() const
{
    return m_controller->mapLoadError();
}

void SearchForWebmapQuickItem::search(const QString keyword)
{
    m_controller->search(keyword);
    m_mapView->setVisible(false);
}

void SearchForWebmapQuickItem::searchNext()
{
    m_controller->searchNext();
}

void SearchForWebmapQuickItem::loadSelectedWebmap(int index)
{
    m_controller->loadSelectedWebmap(index);
}

void SearchForWebmapQuickItem::errorAccepted()
{
    m_controller->errorAccepted();
}

AuthenticationManager *SearchForWebmapQuickItem::authManager() const
{
    return m_controller->authManager();
}
