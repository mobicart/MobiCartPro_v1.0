package com.mobicart.renamed_package.utils.adapters;

import java.util.ArrayList;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.mobicart.renamed_package.R;
import com.mobicart.android.model.FeatureVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * @author mobicart
 * 
 */
public class MoreListAdapter extends BaseAdapter {
	private Activity context;
	private LayoutInflater lInflater;
	private ArrayList<FeatureVO> list;

	/**
	 * @param currentContext
	 * @param list2
	 */
	public MoreListAdapter(Activity currentContext, ArrayList<FeatureVO> list2) {
		this.context = currentContext;
		this.lInflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		this.list = list2;
		
	}

	static class ViewHolder {
		MyCommonView text;
		ImageView img;
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		convertView = lInflater.inflate(R.layout.more_list_layout, null);
		holder = new ViewHolder();
		holder.text = (MyCommonView) convertView
				.findViewById(R.id.more_listTitle_TV);
		holder.img = (ImageView) convertView.findViewById(R.id.more_listImg_IV);
		convertView.setTag(list.get(position).getName());
		try {
			holder.text.setTextColor(Color.parseColor("#"+MobicartCommonData.colorSchemeObj.getHeaderColor()));
		} catch (Exception e) {
			showServerError();
		}
		
		switch (position) {
		case 0:
			if (list.get(position).getName().equalsIgnoreCase("About us")) {
				holder.img.setImageResource(R.drawable.about);
				holder.text.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.more.aboutus", "About Us"));
			}
		case 1:
			if (list.get(position).getName().equalsIgnoreCase("Contact us")) {
				holder.text.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.more.contactus", "Contact Us"));
				holder.img.setImageResource(R.drawable.contact);
			}

		case 2:
			if (list.get(position).getName().equalsIgnoreCase("Terms")) {
				holder.text.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.more.tandc", "Terms And Conditions"));
				holder.img.setImageResource(R.drawable.term);
			}
		case 3:
			if (list.get(position).getName().equalsIgnoreCase("Privacy")) { // holder.text.setText(MobicartCommonData.sPagesVO.get(3).getsTitle());
				holder.img.setImageResource(R.drawable.privacy);
				holder.text.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.more.privacy", "Privacy"));
			}
		case 4:
			if (list.get(position).getName().equalsIgnoreCase("Page 1")) {
				holder.text.setText(MobicartCommonData.sPagesVO.get(4)
						.getsTitle());
				holder.img.setImageResource(R.drawable.delievery_active);
				
			}
		case 5:
			if (list.get(position).getName().equalsIgnoreCase("Page 2"))
			{
				holder.text.setText(MobicartCommonData.sPagesVO.get(5)
						.getsTitle());
				holder.img.setImageResource(R.drawable.delievery_active);
			}
			break;
			default:
		}
		return convertView;
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.context)
		.create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
		"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
		"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
		"key.iphone.nointernet.cancelbutton", "OK"),
		new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
			alertDialog.cancel();
			}
		});
		alertDialog.show();
	}

	@Override
	public int getViewTypeCount() {
		return 1;
	}
}