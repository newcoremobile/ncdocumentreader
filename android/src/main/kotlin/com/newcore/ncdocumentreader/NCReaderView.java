package com.newcore.ncdocumentreader;

import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.tencent.smtt.sdk.TbsReaderView;

import java.io.File;

public class NCReaderView extends FrameLayout implements TbsReaderView.ReaderCallback {

    private static final String TAG = "NCReaderView";
    private TbsReaderView mTbsReaderView;
    private Context mContext;

    public NCReaderView(Context context) {
        this(context, null);
    }

    public NCReaderView(Context context,AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public NCReaderView(Context context,AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mTbsReaderView = new TbsReaderView(context, this);
        this.mContext = context;
        this.addView(mTbsReaderView, new LinearLayout.LayoutParams(-1, -1));
    }

    @Override
    public void onCallBackAction(Integer integer, Object o, Object o1) {

    }

    private OnGetFilePathListener mOnGetFileListener;

    public void setOnGetFilePathListener(OnGetFilePathListener listener) {
        this.mOnGetFileListener = listener;
    }

    public interface OnGetFilePathListener {
        void onGetFilePath(NCReaderView readerView);
    }

    public void displayFile(File file) {
        if (file != null && !TextUtils.isEmpty(file.toString())) {
            //增加下面一句解决没有TbsReaderTemp文件夹存在导致加载文件失败
            String bsReaderTemp = "/storage/emulated/0/TbsReaderTemp";
            File bsReaderTempFile = new File(bsReaderTemp);

            if (!bsReaderTempFile.exists()) {
                Log.d(TAG,"准备创建/storage/emulated/0/TbsReaderTemp！！");
                boolean mkdir = bsReaderTempFile.mkdir();
                if (!mkdir) {
                    Log.e(TAG,"创建/storage/emulated/0/TbsReaderTemp失败！！！！！");
                }
            }

            Bundle localBundle = new Bundle();
            localBundle.putString("filePath",file.toString());
            localBundle.putString("tempPath", Environment.getExternalStorageDirectory()+"/"+"TbsReaderTemp");

            boolean open = mTbsReaderView.preOpen(getFileType(file.toString()),false);
            if(open) {
                this.mTbsReaderView.openFile(localBundle);
            } else {
                Toast.makeText(mContext,"打开失败，暂不支持此文件类型",Toast.LENGTH_SHORT).show();
            }
        }
    }

    /***
     * 获取文件类
     */
    private String getFileType(String paramString) {
        String str = "";
        if (TextUtils.isEmpty(paramString)) {
            return str;
        }
        int i = paramString.lastIndexOf('.');
        if (i <= -1) {
            return str;
        }
        str = paramString.substring(i + 1);
        return str;

    }

    public void onStopDisplay() {
        if (mTbsReaderView != null) {
            mTbsReaderView.onStop();
        }
    }
}




















