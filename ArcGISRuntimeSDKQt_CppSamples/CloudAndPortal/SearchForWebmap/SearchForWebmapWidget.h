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

#ifndef SEARCHFORWEBMAPWIDGET_H
#define SEARCHFORWEBMAPWIDGET_H

class SearchForWebmapController;

namespace Esri
{
    namespace ArcGISRuntime
    {
        class AuthenticationManager;
        class MapGraphicsView;
    }
}

namespace Ui {
 class SearchForWebmapWidget;
}

#include <QAbstractListModel>
#include <QItemDelegate>
#include <QWidget>

class SearchForWebmapWidget : public QWidget
{
    Q_OBJECT

public:
    SearchForWebmapWidget(QWidget* parent = nullptr);
    ~SearchForWebmapWidget();

    Esri::ArcGISRuntime::AuthenticationManager* authManager() const;
    bool portalLoaded() const;
    QAbstractListModel* webmaps() const;
    bool hasMoreResults() const;
    QString mapLoadError() const;

signals:
    void authManagerChanged();
    void portalLoadedChanged();
    void webmapsChanged();
    void hasMoreResultsChanged();
    void mapLoadErrorChanged();

private slots:
    void onSearchNext();
    void onLoadSelectedWebmap(int index);
    void onErrorAccepted();

private:
    Ui::SearchForWebmapWidget* m_ui;
    Esri::ArcGISRuntime::MapGraphicsView* m_mapView;
    SearchForWebmapController* m_controller;
};

class WebmapDelegate : public QItemDelegate
{
public:
    void paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const;

private:
    mutable int m_titleRole = -1;
};

#endif // SEARCHFORWEBMAPWIDGET_H
