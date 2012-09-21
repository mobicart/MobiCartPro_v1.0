package com.mobicart.renamed_package.utils.adapters;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.NewsVO;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.mobicart.renamed_package.utils.ImageLoader;

/**
 * @author mobicart
 * 
 */
public class NewsListAdapter extends BaseAdapter {
	private String dayStrNew;
	private LayoutInflater layoutInflater;
	private Activity activity;
	private ArrayList<NewsVO> newsList;
	private int size = 0;
	private String dayStr="";
	private String day2,str_date;
	/**
	 * 
	 * @param context
	 */
	public NewsListAdapter(Activity context) {
		this.activity = context;
		this.layoutInflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		size = MobicartCommonData.newsList.size();
		newsList = new ArrayList<NewsVO>();
		for (int i = 0; i < size; i++) {
			newsList.add(MobicartCommonData.newsList.get(i));
		}
		if (newsList.get(0).getsType().equalsIgnoreCase("feed")) {
			if (MobicartCommonData.newsList.get(0).isbFeedStatus() == false) {
				newsList.remove(0);
				size = newsList.size();
			} else {
				size = newsList.size();
			}
		} else {
			size = newsList.size();
		}
	}

	@Override
	public int getCount() {
		return size;
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	static class ViewHolder {
		TextView titleTV, dateTV;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		RelativeLayout imgRL = null;
		ViewHolder holder;
		if (convertView == null) {
			convertView = layoutInflater.inflate(R.layout.news_list_layout,
					null);
		}
		holder = new ViewHolder();
		holder.titleTV = (TextView) convertView.findViewById(R.id.list_item_TV);
		imgRL=(RelativeLayout)convertView.findViewById(R.id.listImg_IV);
		holder.dateTV = (TextView) convertView.findViewById(R.id.news_Date_TV);
		holder.titleTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		holder.dateTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		str_date = newsList.get(position).getdDate2();
		java.util.Date dateFormat = newsList.get(position).getdDate();
		SimpleDateFormat sd = new SimpleDateFormat("d");
		SimpleDateFormat sd1 = new SimpleDateFormat("MMMM yyyy");
		if(dateFormat!=null){
		int day = Integer.parseInt(sd.format(dateFormat));
		day2 = sd1.format(dateFormat);
		String dayStr22 = day + MobiCartConstantIds.suffixes[day] + " " + day2;
		if(MobicartCommonData.newsList.get(position).isbFeedStatus() == true){
			dayStr=dayStr22.toUpperCase();
		}		
		DateFormat formatter;
		Date date;
		formatter = new SimpleDateFormat("E,dd MMM yy");
		try {
			if(str_date==null){
				date=newsList.get(position).getdDate();
			}else{
				date = formatter.parse(str_date);	
			}
			SimpleDateFormat sdNew = new SimpleDateFormat("d");
			SimpleDateFormat sd1New = new SimpleDateFormat("MMMM yyyy");
			int dayNew = Integer.parseInt(sdNew.format(date));
			String day2New = sd1New.format(date);
			dayStrNew = dayNew + MobiCartConstantIds.suffixes[dayNew] + " "
					+ day2New;
		} catch (java.text.ParseException e) {
		}
		}
		holder.titleTV.setText(newsList.get(position).getsTitle());
		if (newsList.get(position).getsImage() == null
				|| newsList.get(position).getsImage().equalsIgnoreCase("")) {
			imgRL.setVisibility(View.GONE);
			if (MobicartCommonData.newsList.get(position).isbFeedStatus() == true) {
				holder.dateTV.setText(dayStr);
				convertView.setTag(dayStr);
			} else {
				try{
				holder.dateTV.setText(dayStrNew.toUpperCase());
				convertView.setTag(dayStrNew.toUpperCase());
				}
				catch (Exception e) {
				}
			}
		} else {
			if (MobicartCommonData.newsList.get(position).isbFeedStatus() == true) {
				holder.dateTV.setText(dayStr);
				convertView.setTag(dayStr);
			} else {
				try{
				holder.dateTV.setText(dayStrNew.toUpperCase());
				convertView.setTag(dayStrNew.toUpperCase());
				}
				catch (Exception e) {
				}
			}
			imgRL.setVisibility(View.VISIBLE);
			ImageView imgView;
			ImageLoader imageLoader ;
			imageLoader=new ImageLoader(activity.getApplicationContext());
			imgView=new ImageView(activity);
			imgView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT));
			imgView.setTag(MobicartUrlConstants.baseImageUrl.substring(
					0, MobicartUrlConstants.baseImageUrl.length() - 1)
					+ newsList.get(position).getsImage());
			imageLoader.DisplayImage( MobicartUrlConstants.baseImageUrl.substring(
					0, MobicartUrlConstants.baseImageUrl.length() - 1)
					+ newsList.get(position).getsImage(), activity,imgView);
			imgRL.addView(imgView);	
		}
		return convertView;
	}

	@Override
	public int getViewTypeCount() {
		return 1;
	}
}
