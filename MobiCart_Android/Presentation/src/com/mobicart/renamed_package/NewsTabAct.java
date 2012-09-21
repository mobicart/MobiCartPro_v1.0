package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioGroup;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RadioGroup.OnCheckedChangeListener;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.NewsVO;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.MyRadioButton;
import com.mobicart.renamed_package.utils.AsyncTasks.GetNewsTask;
import com.mobicart.renamed_package.utils.AsyncTasks.GetTwitterTask;
/**
 * This activity class is for the News tab section which host news feed and twitter feeds.
 * @author mobicart
 *
 */
public class NewsTabAct extends Activity implements OnCheckedChangeListener,
		OnItemClickListener, OnClickListener {
	
	private MyRadioButton tweetBtn, newsBtn;
	private RadioGroup radioGroup;
	private ImageView headerIV;
	private MyCommonView headerTitle, backBtn,cartBtn,cartEditBtn;
	private ListView newsLV;
	private ArrayList<NewsVO> newsList;
	@SuppressWarnings("unused")
	private int size=0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.news_layout);
		initializeControls();
		newsListBind();
		newsBtn.setChecked(true);
		radioGroup.setOnCheckedChangeListener(NewsTabAct.this);
		newsLV.setOnItemClickListener(this);
	}

	/**
	 * This method is used for getting list of news and binding it with view controls.
	 */
	private void newsListBind() {
		GetNewsTask newsTask = new GetNewsTask(this.getParent(), newsLV,radioGroup,headerIV,headerTitle);
		newsTask.execute("");
	}
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void initializeControls() {
		newsBtn = (MyRadioButton) findViewById(R.id.news_news_RB);
		tweetBtn = (MyRadioButton) findViewById(R.id.news_twitter_RB);
		radioGroup = (RadioGroup) findViewById(R.id.news_menu);
		headerIV = (ImageView) findViewById(R.id.news_icon_IV);
		headerTitle = (MyCommonView) findViewById(R.id.news_newstitle_TV);
		newsLV = (ListView) findViewById(R.id.news_LV);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		headerTitle.setText(MobicartCommonData.keyValues.getString("key.iphone.news.news","News"));
		newsBtn.setText(MobicartCommonData.keyValues.getString("key.iphone.news.news","News"));
		tweetBtn.setText(MobicartCommonData.keyValues.getString("key.iphone.news.twitter","Twitter"));
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText(""+CartItemCount.getCartCount(this));
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		 switch(checkedId){
		 case R.id.news_news_RB:
		 { try {
					tweetBtn.setBackgroundResource(R.drawable.news_selected);
					newsBtn.setBackgroundResource(R.drawable.twitter_normal);
					headerIV.setImageResource(R.drawable.news_icon);
					headerTitle.setText(MobicartCommonData.keyValues.getString("key.iphone.news.news","News"));
					newsListBind();
					newsLV = (ListView) findViewById(R.id.news_LV);
					newsLV.setOnItemClickListener(this);
					} catch (Exception e) {
					}
			 		 
			 break;
		 }
		 case R.id.news_twitter_RB:
		 {
			    tweetBtn.setBackgroundResource(R.drawable.news_normal);
				newsBtn.setBackgroundResource(R.drawable.twitter_selected);
				headerIV.setImageResource(R.drawable.twitter_icon);
				headerTitle.setText(MobicartCommonData.keyValues.getString("key.iphone.news.twitter","Twitter"));
				twitterListBind();// Method to access Twitter feed data
				cartBtn.setOnClickListener(this);
			 break;
		 }
	 }
	}

	protected void twitterListBind() {
		GetTwitterTask tnewsTask = new GetTwitterTask(this.getParent(), newsLV);
		tnewsTask.execute("");
	}

	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		String newdate=arg1.getTag().toString();
		if (radioGroup.getCheckedRadioButtonId() == newsBtn.getId()) {
			newsList=new ArrayList<NewsVO>();
			for(int i=0;i<MobicartCommonData.newsList.size();i++){				
				newsList.add(MobicartCommonData.newsList.get(i));
			}
			if(MobicartCommonData.newsList.get(0).getsType().equalsIgnoreCase("feed"))
	        {
				if (MobicartCommonData.newsList.get(0).isbFeedStatus() == false) {
					newsList.remove(0);
					size = newsList.size();
				} else {
					size = newsList.size();
				}
		    }else{
	        	size=newsList.size();
	        }
			String str = "" + newsList.get(arg2).getsTitle();
			String desC = "" + newsList.get(arg2).getsBody();
			Intent intent = new Intent(NewsTabAct.this, NewsDetailsAct.class);
			intent.putExtra("title", str);
			intent.putExtra("date",newdate);
			intent.putExtra("des", desC);
			NewsTabGroup parentActivity = (NewsTabGroup) getParent();
			parentActivity.startChildActivity("NewsDetailsAct", intent);
		}
	}
	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart="NotSplash";
		super.onPause();
	}
	@Override
	protected void onResume() {
		backBtn.setVisibility(View.GONE);
		cartBtn.setText(""+CartItemCount.getCartCount(this));
		cartBtn.setOnClickListener(this);
		super.onResume();
	}
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
	    if ((keyCode == KeyEvent.KEYCODE_BACK)) {
	          return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onClick(View v) {
		   NewsTabGroup parentActivity = (NewsTabGroup) getParent();
		   Intent cartAct = new Intent(this, CartAct.class);
		   String backBtn=MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.news", "News");
		   cartAct.putExtra("IsFrom",backBtn);
		   if(newsBtn.isChecked()==true){
			    cartAct.putExtra("ParentAct", "0");}
		   else{
			    cartAct.putExtra("ParentAct", "6");}
		   parentActivity.startChildActivity("CartAct", cartAct);
	}
	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart="NotSplash";
		super.onDestroy();
	}
}