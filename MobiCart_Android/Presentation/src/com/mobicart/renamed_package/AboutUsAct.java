package com.mobicart.renamed_package;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Display;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.URLInHtmlHrefUtil;

/**
 * This Activity Class contains the Information regarding App.
 * 
 * @author mobicart
 * 
 */
public class AboutUsAct extends Activity implements OnClickListener {

	private MyCommonView TitleTV, backBtn, cartBtn, cartEditBtn;
	private ImageView TitleIV;
	private WebView descWV;
	private int TitleImage;
	private String Title;
	private String Desc;
	private ProgressDialog progressDialog;
	private Boolean firstTime = true;

	@SuppressLint("SetJavaScriptEnabled")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.aboutus_layout);
		Bundle extra = getIntent().getExtras();
		Title = extra.getString("Title");
		Desc = extra.getString("Descripition");
		TitleImage = extra.getInt("Image");
		prepareViewControls();
		TitleTV.setText(Title);
		backBtn.setOnClickListener(this);
		cartBtn.setOnClickListener(this);
		Desc=URLInHtmlHrefUtil.getStringInHtmlHrefFormat(Desc);
		String webDesc = "<html><body><font face='Helvetica-Bold' size=2.95 "
				+ "'>" + Desc + "</font></body></html>";
		webDesc = "<html><body><font face='Helvetica-Bold' size=2.95 color='"
				+ Color.parseColor("#"
						+ MobicartCommonData.colorSchemeObj.getLabelColor())
				+ "'>" + Desc + "</font></body></html>";
		descWV.getSettings().setJavaScriptEnabled(true);
		descWV.loadDataWithBaseURL("", webDesc, "text/html", "UTF-8", null);
		descWV.setVerticalScrollBarEnabled(false);
		descWV.setHorizontalScrollBarEnabled(false);
		descWV.setBackgroundColor(0);
		descWV.setWebViewClient(new InsideWebViewClient());
		descWV.getSettings().setBuiltInZoomControls(false);
		descWV.setBackgroundResource(R.drawable.main_bg);
		descWV.requestFocus(View.FOCUS_DOWN);
	}
	
	private class InsideWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			view.loadUrl(url);
			return true;
		}
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
			progressDialog.setMessage(MobicartCommonData.keyValues.getString(
					"key.iphone.LoaderText", ""));
			progressDialog.setCancelable(false);
			progressDialog.show();
			if (!firstTime) {
				Double width = (double) descWV.getWidth();
				descWV.setInitialScale(getScale(width));
			}
			firstTime = false;
		}
		
		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			progressDialog.dismiss();
		}
	}
	@SuppressLint("UseValueOf")
	private int getScale(Double width2) {
		Display display = ((WindowManager) getSystemService(Context.WINDOW_SERVICE))
				.getDefaultDisplay();
		int width = display.getWidth();
		Double val = new Double(width) / 12;
		return val.intValue();
	}
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		TitleIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		TitleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		descWV = (WebView) findViewById(R.id.aboutUs_text_WV);
		progressDialog = new ProgressDialog(AboutUsAct.this.getParent());
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);

		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		TitleIV.setImageDrawable(getResources().getDrawable(TitleImage));
		cartBtn.setVisibility(View.VISIBLE);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.more", "More"));
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.more", "More"));
		backBtn.setOnClickListener(this);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		super.onResume();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		case R.id.navigation_bar_cart_btn:
			MoreTabGroupAct parentActivity = (MoreTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = TitleTV.getText().toString();
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "5");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		}
	}

	@Override
	protected void onStop() {
		backBtn.setVisibility(View.GONE);
		super.onStop();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.GONE);
		super.onDestroy();
	}
}
