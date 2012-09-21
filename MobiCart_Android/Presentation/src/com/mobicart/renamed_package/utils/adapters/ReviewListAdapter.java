package com.mobicart.renamed_package.utils.adapters;

import org.json.JSONException;

import android.app.Activity;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RatingBar;
import com.mobicart.renamed_package.R;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * @author mobicart
 */
public class ReviewListAdapter extends BaseAdapter {

	private Activity context;
	private ProductVO pReview;
	private Product getProduct;

	public ReviewListAdapter(Activity activity, int currentProductId)
			throws NullPointerException, JSONException, CustomException {
		this.context = activity;
		getProduct = new Product();
		pReview = getProduct.getProductDetails(context, currentProductId);
	}

	@Override
	public int getCount() {
		return pReview.getProductReviews().size();
	}

	@Override
	public Object getItem(int position) {
		return true;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (context).getLayoutInflater();
		View v = inflater.inflate(R.layout.review_listlayout, null);
		MyCommonView listTitle = (MyCommonView) v
				.findViewById(R.id.review_listTitle_TV);
		MyCommonView listDesc = (MyCommonView) v
				.findViewById(R.id.review_listDesc_TV);
		RatingBar iRating = (RatingBar) v
				.findViewById(R.id.review_listrating_RatingBar);

		listDesc.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		listTitle.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.read.reviews.by", "Write Review")
				+ " "
				+ pReview.getProductReviews().get(position).getsReveiwerName());
		if (pReview.getProductReviews().get(position).getsReview().length() > 0) {
			listDesc.setVisibility(View.VISIBLE);
			listDesc.setText(pReview.getProductReviews().get(position)
					.getsReview());
		}
		iRating.setRating(pReview.getProductReviews().get(position)
				.getiRating());
		return v;
	}
}
