package com.newcore.ncdocumentreader

import android.app.Activity
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.tencent.smtt.sdk.QbSdk
import com.tencent.smtt.sdk.TbsListener

class NcDocumentReaderPlugin(private val activity: Activity) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "nc_document_reader")
            initX5Env(registrar)
            channel.setMethodCallHandler(NcDocumentReaderPlugin(registrar.activity()))
        }

        private fun initX5Env(registrar: Registrar) {
            QbSdk.setDownloadWithoutWifi(true);
            QbSdk.initX5Environment(registrar.activity().applicationContext, object : QbSdk.PreInitCallback {
                override fun onViewInitFinished(init: Boolean) {
                    Log.d("X5", " onViewInitFinished is $init");
                }

                override fun onCoreInitFinished() {
                }
            })
            QbSdk.setTbsListener(object : TbsListener {
                override fun onDownloadFinish(p0: Int) {
                    Log.d("X5", "X5内核下载完毕:$p0");
                }

                override fun onDownloadProgress(p0: Int) {
                    Log.d("X5", "X5内核正在下载：$p0");
                }

                override fun onInstallFinish(p0: Int) {
                    Log.d("X5", "x5内核安装完成：$p0");
                }
            })
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.equals("openFile")) {
            if (call.hasArgument("filePath")) {
                val filePath:String? = call.argument("filePath")
                val title:String? = call.argument("fileName")
                FileDisplayActivity.start(activity, title, filePath)
                result.success("success")
            }
        } else {
            result.notImplemented()
        }
    }

}
