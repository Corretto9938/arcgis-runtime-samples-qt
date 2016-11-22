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
#include "MapGraphicsView.h"
#include "SearchForWebmapWidget.h"
#include "SearchForWebmapController.h"
#include "ui_SearchForWebmapWidget.h"

using namespace Esri::ArcGISRuntime;

SearchForWebmapWidget::SearchForWebmapWidget(QWidget* parent /* = nullptr */):
    QWidget(parent),
    m_ui(new Ui::SearchForWebmapWidget()),
    m_mapView(new MapGraphicsView(this)),
    m_controller(new SearchForWebmapController(this))
{
    m_ui->setupUi(this);

    connect(m_controller, &SearchForWebmapController::portalLoadedChanged, this, [this](){
        m_ui->searchtextLineEdit->setEnabled(portalLoaded());
        m_ui->searchPushButton->setEnabled(portalLoaded());
    });

    connect(m_controller, &SearchForWebmapController::webmapsChanged, this, [this](){
        m_ui->webmapsListView->setModel(webmaps());
        m_ui->webmapsListView->setEnabled(webmaps() != nullptr );
    });

    connect(m_controller, &SearchForWebmapController::hasMoreResultsChanged, this, [this](){
        m_ui->searchMore->setEnabled(hasMoreResults());
    });

//    connect(m_controller, &SearchForWebmapController::mapLoadErrorChanged, this, &SearchForWebmapWidget::mapLoadErrorChanged);
//    connect(m_controller, &SearchForWebmapController::authManagerChanged, this, &SearchForWebmapWidget::authManagerChanged);

    connect(m_controller, &SearchForWebmapController::mapLoaded, this, [this](){
        if (!m_mapView)
            return;

        m_mapView->setMap(m_controller->map());
        m_mapView->setVisible(true);
    });

    connect(m_ui->searchPushButton, &QPushButton::clicked, this, [this](){
        m_controller->search(m_ui->searchtextLineEdit->text());
        m_mapView->setVisible(false);
    });

    connect(m_ui->searchMore, &QPushButton::clicked, this, [this](){
        m_controller->searchNext();
    });

    connect(m_ui->webmapsListView, &QListView::doubleClicked, this, [this](const QModelIndex& clickedIdx){
        m_controller->loadSelectedWebmap(clickedIdx.row());
    });

    m_controller->setUsernamePassord("*****", "*****");
    m_mapView->setWrapAroundMode(WrapAroundMode::Disabled);
    m_mapView->setMinimumWidth(500);
    m_mapView->setMinimumHeight(500);
    m_ui->searchtextLineEdit->setEnabled(false);
    m_ui->searchPushButton->setEnabled(false);
    m_ui->webmapsListView->setEnabled(false);
    m_ui->webmapsListView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    WebmapDelegate* del = new WebmapDelegate();
    m_ui->webmapsListView->setItemDelegate(del);
    m_ui->searchMore->setEnabled(false);
    m_ui->gridLayout->addWidget(m_mapView, 0, 1, 4, 1, Qt::AlignCenter);
    m_ui->gridLayout->setColumnMinimumWidth(1, 500);

    m_controller->init();
}

SearchForWebmapWidget::~SearchForWebmapWidget()
{

}

bool SearchForWebmapWidget::portalLoaded() const
{
    return m_controller->portalLoaded();
}

QAbstractListModel* SearchForWebmapWidget::webmaps() const
{
    return m_controller->webmaps();
}

bool SearchForWebmapWidget::hasMoreResults() const
{
    return m_controller->hasMoreResults();
}

QString SearchForWebmapWidget::mapLoadError() const
{
    return m_controller->mapLoadError();
}


void SearchForWebmapWidget::onSearchNext()
{
    m_controller->searchNext();
}

void SearchForWebmapWidget::onLoadSelectedWebmap(int index)
{
    m_controller->loadSelectedWebmap(index);
}

void SearchForWebmapWidget::onErrorAccepted()
{
    m_controller->errorAccepted();
}

AuthenticationManager *SearchForWebmapWidget::authManager() const
{
    return m_controller->authManager();
}

void WebmapDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    if (m_titleRole == -1)
    {
        QHash<int,QByteArray> roleNames = index.model()->roleNames();
        for (QHash<int,QByteArray>::const_iterator it = roleNames.begin(); it != roleNames.end(); ++it)
        {
            QString roleName = QString::fromStdString(it.value().toStdString());
            if (roleName.compare("title") == 0)
            {
                m_titleRole = it.key();
                break;
            }
        }
    }

    if (m_titleRole == -1)
        return;

    if (option.state & QStyle::State_Selected)
        painter->fillRect(option.rect, option.palette.highlight());

    QString title =  index.model()->data(index, m_titleRole).toString();
    painter->save();
    painter->drawText(option.rect, title);
    painter->restore();
}
