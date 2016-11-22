// Copyright 2015 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <QApplication>
#include <QMainWindow>
#include <QCommandLineParser>
#include <QDir>
#ifdef QT_WEBVIEW_WEBENGINE_BACKEND
#include <QtWebEngine>
#endif // QT_WEBVIEW_WEBENGINE_BACKEND

#ifdef Q_OS_WIN
#include <Windows.h>
#endif

#include "SearchForWebmapWidget.h"

using namespace Esri::ArcGISRuntime;

int main(int argc, char *argv[])
{
#ifdef Q_OS_WIN
  // Force usage of OpenGL ES through ANGLE on Windows
  QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);
#endif

  QApplication a(argc, argv);

#ifdef QT_WEBVIEW_WEBENGINE_BACKEND
  QtWebEngine::initialize();
#endif // QT_WEBVIEW_WEBENGINE_BACKEND

  QMainWindow w;
  SearchForWebmapWidget* sampleWidget = new SearchForWebmapWidget(&w);
  w.setCentralWidget(sampleWidget);
  w.show();

  return a.exec();
}
