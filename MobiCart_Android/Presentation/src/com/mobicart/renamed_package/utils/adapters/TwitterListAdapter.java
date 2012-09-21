package com.mobicart.renamed_package.utils.adapters;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Bitmap.Config;
import android.graphics.PorterDuff.Mode;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.mobicart.renamed_package.R;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This is TwitterListAdapter to display tweets in List.
 * 
 * @author mobicart
 */
public class TwitterListAdapter extends BaseAdapter 
		 {

	private Context context;
	private LayoutInflater layoutInflater;

	/**
	 * @param context
	 */
	public TwitterListAdapter(Context context) {
		this.context = context;
		this.layoutInflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@Override
	public int getCount() {
		return MobicartCommonData.tweetFeedVO.size();
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
		MyCommonView title, desC;
		ImageView img;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		convertView = layoutInflater
				.inflate(R.layout.twitter_news_layout, null);
		holder = new ViewHolder();
		holder.title = (MyCommonView) convertView
				.findViewById(R.id.twitter_list_title_TV);
		holder.img = (ImageView) convertView
				.findViewById(R.id.twitter_listImg_IV);
		holder.desC = (MyCommonView) convertView
				.findViewById(R.id.twitter_listsize_TV);
		convertView.setTag(holder);
		holder = (ViewHolder) convertView.getTag();
		String text = MobicartCommonData.tweetFeedVO.get(position).getText();
		try {
			holder.desC.gatherLinksForText(text.trim());
		} catch (Exception e1) {
		}
		holder.desC.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		holder.desC.setLinkTextColor(Color.RED);
		holder.title.setText(MobicartCommonData.tweetFeedVO.get(position)
				.getFrom_user());
		holder.title.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		try {
			String url = MobicartCommonData.tweetFeedVO.get(position)
					.getProfile_image_url();

			Bitmap bitmap = BitmapFactory.decodeStream((InputStream) new URL(
					url).getContent());
			if (bitmap != null) {
				holder.img.setImageBitmap(getRoundedCornerBitmap(bitmap));
			} else {
				holder.img
						.setImageBitmap(getRoundedCornerBitmap(BitmapFactory
								.decodeStream((InputStream) new URL(
										MobicartCommonData.tweetFeedVO.get(0)
												.getProfile_image_url())
										.getContent())));

			}

		} catch (MalformedURLException e) {
			showServerError();
		} catch (IOException e) {
			showServerError();
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

	/**
	 * @param bitmap
	 * @return
	 */
	public static Bitmap getRoundedCornerBitmap(Bitmap bitmap) {
		Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap
				.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(output);
		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		final RectF rectF = new RectF(rect);
		final float roundPx = 12;
		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);
		return output;
	}

	
}