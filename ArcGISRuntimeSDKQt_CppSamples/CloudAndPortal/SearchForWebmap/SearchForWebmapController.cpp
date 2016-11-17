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

#include "AuthenticationManager.h"
#include "Map.h"
#include "Basemap.h"
#include "Portal.h"
#include "PortalItem.h"
#include "PortalItemListModel.h"
#include "PortalQueryParametersForItems.h"
#include "SearchForWebmapController.h"

#include <QAbstractListModel>

using namespace Esri::ArcGISRuntime;

SearchForWebmapController::SearchForWebmapController(QObject* parent /* = nullptr */):
    QObject(parent),
    m_map(nullptr),
    m_portal(new Portal(new Credential(OAuthClientInfo("W3hPKzPbeJ0tr8aj", OAuthMode::User), this), this)),
    m_webmapResults(nullptr),
    m_webmaps(nullptr),
    m_selectedItem(nullptr),
    m_portalLoaded(false)
{
    AuthenticationManager::instance()->setCredentialCacheEnabled(false);

    connect(m_portal, &Portal::loadStatusChanged, this, [this](){
        m_portalLoaded = m_portal->loadStatus() == LoadStatus::Loaded;
        emit portalLoadedChanged();
    });

    connect(m_portal, &Portal::findItemsCompleted, this, [this](PortalQueryResultSetForItems *webmapResults){
        m_webmapResults = webmapResults;
        m_webmaps = m_webmapResults->itemResults();
        emit webmapsChanged();
        emit hasMoreResultsChanged();
    });
}

SearchForWebmapController::~SearchForWebmapController()
{

}

bool SearchForWebmapController::portalLoaded() const
{
    return m_portalLoaded;
}

QAbstractListModel* SearchForWebmapController::webmaps() const
{
    return m_webmaps;
}

bool SearchForWebmapController::hasMoreResults() const
{
    return m_webmapResults && m_webmapResults->nextQueryParameters().startIndex() > -1;
}

QString SearchForWebmapController::mapLoadError() const
{
    return m_mapLoadeError;
}

void SearchForWebmapController::search(const QString keyword)
{
    PortalQueryParametersForItems query;
    query.setSearchString(QString("tags:\"%1\"").arg(keyword));
    query.setTypes(QList<PortalItemType>() << PortalItemType::WebMap);
    m_portal->findItems(query);
}

void SearchForWebmapController::searchNext()
{
    if (!m_webmapResults || m_webmapResults->nextQueryParameters().startIndex() == -1)
        return;

    m_portal->findItems(m_webmapResults->nextQueryParameters());
}

void SearchForWebmapController::loadSelectedWebmap(int index)
{
    if (!m_webmaps)
        return;

    PortalItem* selectedItem = m_webmaps->at(index);
    if (!selectedItem)
        return;

    if (m_selectedItem)
        m_selectedItem->disconnect();

    m_selectedItem = selectedItem;

    connect(m_selectedItem, &PortalItem::loadStatusChanged, this, [this]{
        if (!m_selectedItem || m_selectedItem->loadStatus() != LoadStatus::Loaded)
            return;

        if (m_map)
            m_map->disconnect();

        m_mapLoadeError.clear();
        emit mapLoadErrorChanged();

        m_map = new Map(m_selectedItem, this);

        connect(m_map, &Map::errorOccurred, this, [this](){
            m_mapLoadeError = m_map->loadError().message();
            emit mapLoadErrorChanged();
        });

        connect(m_map, &Map::loadStatusChanged, this, [this](){
            if (!m_map || m_map->loadStatus() != LoadStatus::Loaded)
                return;

            emit mapLoaded();
        });

        m_map->load();
    });
    m_selectedItem->load();
}

void SearchForWebmapController::errorAccepted()
{
    m_mapLoadeError.clear();
    emit mapLoadErrorChanged();
}

AuthenticationManager *SearchForWebmapController::authManager() const
{
    return AuthenticationManager::instance();
}

Map *SearchForWebmapController::map() const
{
    return m_map;
}

void SearchForWebmapController::init()
{
    emit authManagerChanged();
    m_portal->load();
}
