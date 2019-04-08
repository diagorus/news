package com.fuh.news

import android.support.multidex.MultiDex
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        MultiDex.install(this)
    }
}
