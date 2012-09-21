package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.ViewFlipper;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.GalleryImage;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.GalleryImageVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.ImageLoader;

/**
 * 
 * @author mobicart
 * 
 */
public class GetBannersTask extends
		AsyncTask<String, String, ArrayList<GalleryImageVO>> {

	private ProgressDialog progressDialog;
	private Activity currentContext;
	private ViewFlipper bannersVF;
	private boolean error = true;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;
	public ImageLoader imageLoader;

	/**
	 * 
	 * @param activity
	 * @param bannersVF
	 */
	public GetBannersTask(Activity activity, ViewFlipper bannersVF) {

		this.bannersVF = bannersVF;
		currentContext = activity;
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", "Loader"));
		progressDialog.setCancelable(false);
		imageLoader = new ImageLoader(activity.getApplicationContext());
	}

	protected void onPostExecute(ArrayList<GalleryImageVO> result) {
		if (error == true) {
			String url = "";
			for (int iIndex = 0; iIndex < result.size(); iIndex++) {
				GalleryImageVO gal = result.get(iIndex);
				ImageView bannerIV = null;
				RelativeLayout bannerRL = null;
				LayoutParams params = null;
				if (gal.getsThumbnail() != null) {
					url = gal.getsThumbnail();
					bannerRL = new RelativeLayout(currentContext);
					bannerIV = new ImageView(currentContext);
					params = new LayoutParams(LayoutParams.FILL_PARENT,
							LayoutParams.FILL_PARENT);
					bannerRL.setLayoutParams(params);
					bannerRL.setGravity(Gravity.CENTER);
					bannerIV.setLayoutParams(new LayoutParams(
							LayoutParams.WRAP_CONTENT,
							LayoutParams.WRAP_CONTENT));
					bannerIV.setTag(MobicartUrlConstants.baseUrl.substring(0,
							MobicartUrlConstants.baseUrl.length() - 1) + url);
					imageLoader.DisplayImage(
							MobicartUrlConstants.baseUrl.substring(0,
									MobicartUrlConstants.baseUrl.length() - 1)
									+ url, currentContext, bannerIV);
					if(MobicartCommonData.colorSchemeObj.getThemeColor()!=null)
					{
					bannerRL.setBackgroundColor(Color.parseColor("#"
							+ MobicartCommonData.colorSchemeObj.getThemeColor()));
					}
					bannerRL.addView(bannerIV);
					bannersVF.addView(bannerRL);
				} else {

				}
			}
		}else {
			if (isNetworkNotAvailable) {
				showNetworkError();
			} else
				showServerError();
		}
			try {
				progressDialog.dismiss();
				progressDialog = null;
			} catch (Exception e) {
			}
		super.onPostExecute(result);
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(currentContext)
				.create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.text", "Network Error"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(Intent.ACTION_MAIN);
						intent.addCategory(Intent.CATEGORY_HOME);
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						currentContext.startActivity(intent);
						currentContext.finish();
					}
				});

		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(currentContext)
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
	protected void onPreExecute() {
		progressDialog.show();
		super.onPreExecute();
	}

	@Override
	protected ArrayList<GalleryImageVO> doInBackground(String... params) {
		ArrayList<GalleryImageVO> img = new ArrayList<GalleryImageVO>();
		img = getBannerImageData();
		return img;
	}

	private ArrayList<GalleryImageVO> getBannerImageData() {
		if (MobicartCommonData.galleryImages.size() > 0) {
			MobicartCommonData.isHomeCreated = true;
		} else {
			GalleryImage galleryImage = new GalleryImage();
			try {
				MobicartCommonData.galleryImages = galleryImage
						.getHomeGalleriesByStore(currentContext,
								MobicartCommonData.appIdentifierObj
										.getStoreId());
			} catch (NullPointerException e) {
				objMobicartLogger.LogExceptionMsg(
						reqDateFormat.format(new Date()), e.getMessage());
				error = false;
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(
						reqDateFormat.format(new Date()), e.getMessage());
				error = false;
			} catch (CustomException e) {
				objMobicartLogger.LogExceptionMsg(
						reqDateFormat.format(new Date()), e.getMessage());
				error = false;
				isNetworkNotAvailable = true;
			}
		}
		return MobicartCommonData.galleryImages;
	}
}