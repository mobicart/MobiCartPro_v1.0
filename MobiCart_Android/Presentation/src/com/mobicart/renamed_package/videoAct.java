package com.mobicart.renamed_package;

import android.app.Activity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This activity is used to play videos of product in webView.
 * @author mobicart
 * 
 */
public class videoAct extends Activity implements OnClickListener {

	private MyCommonView backBtn;
	private String st1;
	private WebView webview;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.watchvideo_layout);
		prepareViewControls();
		Bundle extra = getIntent().getExtras();
		st1 = extra.getString("Url");
		WebSettings webSettings = webview.getSettings();
		webSettings.setJavaScriptEnabled(true);
		webview.loadUrl(st1);
		webview.setWebViewClient(new HelloWebViewClient());
		backBtn.setOnClickListener(this);
	}
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		webview = (WebView) findViewById(R.id.video_WV);
		webview.getSettings().setJavaScriptEnabled(true);

		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
	}

	public class HelloWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			view.loadUrl(url);
			return true;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		MobicartCommonData.isFromStart = "NotSplash";
		if ((keyCode == KeyEvent.KEYCODE_BACK) && webview.canGoBack()) {
			webview.goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onBackPressed() {
		finish();
		super.onBackPressed();
	}

	@Override
	public void onClick(View v) {
		finish();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.department.store", "Store"));
		super.onDestroy();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}
}
