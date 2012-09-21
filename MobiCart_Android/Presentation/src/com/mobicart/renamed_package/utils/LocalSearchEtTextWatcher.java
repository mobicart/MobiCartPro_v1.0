package com.mobicart.renamed_package.utils;

import java.util.ArrayList;

import android.app.Activity;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.ListView;

import com.mobicart.renamed_package.ProductsListAct;
import com.mobicart.renamed_package.StoreTabGroupAct;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.utils.adapters.DepartmentsListAdapter;

/**
 * This class extends TextWatcher used to control local search functionality in
 * app.
 * 
 * @author mobicart
 * 
 */
public class LocalSearchEtTextWatcher implements TextWatcher {

	private ListView productLV;
	private Activity activity;
	private ArrayList<ProductVO> listToSort;
	public static ProductVO[] searchedList;

	/**
	 * @param activity
	 * @param productLV
	 * @param listToSort
	 */
	public LocalSearchEtTextWatcher(Activity activity, ListView productLV,
			ArrayList<ProductVO> listToSort) {
		this.productLV = productLV;
		this.activity = activity;
		this.listToSort = listToSort;
	}

	@Override
	public void afterTextChanged(Editable s) {
		ProductsListAct.isInSearchMode = true;
		searchedList = searchList(s.toString());
		productLV.setAdapter(new DepartmentsListAdapter(activity,
				StoreTabGroupAct.TYPE_PRODUCTS, searchedList));
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count,
			int after) {
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
	}

	private ProductVO[] searchList(String query) {
		ArrayList<ProductVO> searchedList = new ArrayList<ProductVO>();
		int listSize = MobicartCommonData.productsList.size();
		for (int i = 0; i < listSize; i++) {
			if (MobicartCommonData.productsList.get(i).getsName().toUpperCase()
					.startsWith(query.toUpperCase())
					|| MobicartCommonData.productsList.get(i).getsName()
							.toLowerCase().startsWith(query.toLowerCase())) {

				searchedList.add(MobicartCommonData.productsList.get(i));
			}
		}
		listToSort.addAll(searchedList);
		return searchedList.toArray(new ProductVO[] {});
	}
}
