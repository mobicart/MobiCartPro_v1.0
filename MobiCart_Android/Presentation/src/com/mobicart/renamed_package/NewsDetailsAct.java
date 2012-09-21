package com.mobicart.renamed_package;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity is used for displaying news detail.
 * 
 * @author mobicart
 * 
 */
public class NewsDetailsAct extends Activity implements OnClickListener {

	private MyCommonView headingTV, TitleTV, backBtn, dateTV, cartBtn,cartEditBtn;
	private ImageView imageIV;
	private WebView detatil_newsWV;
	private String newsDiscripition, newsTitle, newsdescp, newsDate,
			newsDispColor;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.news_dec_layout);
		prepareControlViews();
		
		cartBtn.setOnClickListener(this);
		Bundle extra = getIntent().getExtras();
		newsTitle = extra.getString("title");
		newsdescp = extra.getString("des");
		newsDate = extra.getString("date");
		backBtn.setOnClickListener(this);
		newsDispColor = "#" + MobicartCommonData.colorSchemeObj.getLabelColor();
		if (newsdescp.contains("src=\"")) {
			if (newsdescp.contains("src=\"http:")) {
				newsDiscripition = "<html><body><font face='Helvetica-Bold' size=2.95 color='"
						+ newsDispColor
						+ "'>"
						+ newsdescp
						+ "</font></body></html>";
			} else {
				String seperated[] = newsdescp.split("src=\"");
				newsDiscripition = "<html><body><font face='Helvetica-Bold' size=2.95 color='"
						+ newsDispColor
						+ "'>"
						+ seperated[0]
						+ "src=\"http:"
						+ seperated[1] + "</font></body></html>";
			}
		} else
			newsDiscripition = "<html><body><font face='Helvetica-Bold' size=2.95 color='"
					+ newsDispColor
					+ "'>"
					+ newsdescp
					+ "</font></body></html>";
		detatil_newsWV.getSettings().setJavaScriptEnabled(true);
		detatil_newsWV.setVerticalScrollBarEnabled(true);
		detatil_newsWV.setHorizontalScrollBarEnabled(true);
		detatil_newsWV.loadDataWithBaseURL("", newsDiscripition, "text/html",
				"UTF-8", null);
		detatil_newsWV.setBackgroundColor(Color.parseColor("#efebef"));
		detatil_newsWV.setWebViewClient(new InsideWebViewClient());
		detatil_newsWV.getSettings().setBuiltInZoomControls(false);
		detatil_newsWV.requestFocus(View.FOCUS_DOWN);
		headingTV.setText(newsTitle);
		headingTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		dateTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		if (newsDate.equalsIgnoreCase("1st January 1970")) {
			dateTV.setText("");
		} else {
			dateTV.setText(newsDate);
		}
	}
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareControlViews() {
		imageIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);	
		TitleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		headingTV = (MyCommonView) findViewById(R.id.news_dec_item);
		dateTV = (MyCommonView) findViewById(R.id.news_dec_Date);
		detatil_newsWV = (WebView) findViewById(R.id.news_desctext_TV);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		
		imageIV.setImageDrawable(getResources().getDrawable(
				R.drawable.news_icon));
		TitleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.news", "News"));
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.news", "News"));
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
	}

	@Override
	protected void onResume() {
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.news", "News"));
		backBtn.setOnClickListener(this);
		super.onResume();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.INVISIBLE);
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		case R.id.navigation_bar_cart_btn:
			NewsTabGroup parentActivity = (NewsTabGroup) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "3");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		}
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	private class InsideWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			view.loadUrl(url);
			return true;
		}
	}
}