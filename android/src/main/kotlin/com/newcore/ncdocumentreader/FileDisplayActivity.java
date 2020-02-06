package com.newcore.ncdocumentreader;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import java.io.File;

public class FileDisplayActivity extends Activity {

    public static void start(Context context,String title,String fileUrl) {
        Intent intent = new Intent(context,FileDisplayActivity.class);
        intent.putExtra("title",title);
        intent.putExtra("fileUrl",fileUrl);
        context.startActivity(intent);
    }

    private NCReaderView mReaderView;
    private TextView mTvTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(getActionBar() != null) getActionBar().hide();
        setContentView(R.layout.activity_file_display);
        mReaderView = findViewById(R.id.readerView);
        mTvTitle = findViewById(R.id.tv_title);
        findViewById(R.id.iv_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        String title = getIntent().getStringExtra("title");
        String fileUrl = getIntent().getStringExtra("fileUrl");
        mReaderView.displayFile(new File(fileUrl));
        mTvTitle.setText(title);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mReaderView.onStopDisplay();
    }

}




























