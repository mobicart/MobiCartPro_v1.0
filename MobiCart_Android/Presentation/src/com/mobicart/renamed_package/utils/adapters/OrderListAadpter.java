package com.mobicart.renamed_package.utils.adapters;

import android.app.Activity;
import android.database.DataSetObserver;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListAdapter;
import com.mobicart.renamed_package.R;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * @author mobicart
 * 
 */
public class OrderListAadpter implements ListAdapter {

	private Activity context;

	public OrderListAadpter(Activity orderHistory) {
		this.context = orderHistory;
	}

	@Override
	public boolean areAllItemsEnabled() {
		return false;
	}

	@Override
	public boolean isEnabled(int position) {
		return false;
	}

	@Override
	public int getCount() {
		return MobicartCommonData.productOrderVO.size();
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
	public int getItemViewType(int position) {
		return 0;
	}

	static class ViewHolder {
		MyCommonView priceTV, dateTV, statusLabelTV, statusTV, orderValTV,
				dateTitleTV, orderIdTV, orderTitleTV;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (context).getLayoutInflater();
		ViewHolder holder;
		if (convertView == null) {
			convertView = inflater.inflate(R.layout.order_listlayout, null);
			holder = new ViewHolder();
			holder.priceTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_total_Price_TV);
			holder.dateTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_date_TV);
			holder.statusLabelTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_statusLable_TV);
			holder.statusTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_status_TV);
			holder.orderValTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_valId_TV);
			holder.dateTitleTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_dateTitle_TV);
			holder.orderIdTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_orderId_TV);
			holder.orderTitleTV = (MyCommonView) convertView
					.findViewById(R.id.orderList_Total_TV);
			holder.dateTitleTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			holder.orderIdTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			holder.orderTitleTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			holder.statusLabelTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			holder.priceTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getLabelColor()));
			holder.dateTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getLabelColor()));
			holder.orderValTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getLabelColor()));
			holder.statusTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getLabelColor()));
			convertView.setTag(holder);
		} else {

			holder = (ViewHolder) convertView.getTag();
		}
		holder.priceTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", MobicartCommonData.productOrderVO.get(
						position).getfTotalAmount()));
		holder.dateTV.setText(""
				+ MobicartCommonData.productOrderVO.get(position)
						.getFormattedOrderDate());
		if (MobicartCommonData.productOrderVO.get(position).getsStatus()
				.equalsIgnoreCase("completed")) {
			holder.statusTV
					.setText(modifyName(MobicartCommonData.productOrderVO.get(
							position).getsStatus()));
		} else if (MobicartCommonData.productOrderVO.get(position).getsStatus()
				.equalsIgnoreCase("processing")) {
			holder.statusTV
					.setText(modifyName(MobicartCommonData.productOrderVO.get(
							position).getsStatus()));
		} else if (MobicartCommonData.productOrderVO.get(position).getsStatus()
				.equalsIgnoreCase("pending")) {
			holder.statusTV
					.setText(modifyName(MobicartCommonData.productOrderVO.get(
							position).getsStatus()));
		} else if (MobicartCommonData.productOrderVO.get(position).getsStatus()
				.equalsIgnoreCase("cancel")) {
			holder.statusTV
					.setText(modifyName(MobicartCommonData.productOrderVO.get(
							position).getsStatus()));
		}
		holder.orderValTV.setText(""
				+ MobicartCommonData.productOrderVO.get(position).getId());
		return convertView;
	}

	private String modifyName(String strToModify) {
		StringBuilder b = new StringBuilder(strToModify);
		int i = 0;
		do {
			b.replace(i, i + 1, b.substring(i, i + 1).toUpperCase());
			i = b.indexOf(" ", i) + 1;
		} while (i > 0 && i < b.length());
		return b.toString();
	}

	@Override
	public int getViewTypeCount() {
		return 1;
	}

	@Override
	public boolean hasStableIds() {
		return false;
	}

	@Override
	public boolean isEmpty() {
		return false;
	}

	@Override
	public void registerDataSetObserver(DataSetObserver observer) {

	}

	@Override
	public void unregisterDataSetObserver(DataSetObserver observer) {

	}
}
