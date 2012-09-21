package com.mobicart.renamed_package.utils;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.http.util.ByteArrayBuffer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Message;
import android.os.Handler.Callback;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.model.MobicartCommonData;

/**
 * Free for anyone to use, just say thanks and share <img
 * src="http://www.anddev.org/images/smilies/smile.png" alt=":-)" title="Smile"
 * />
 * 
 * @author Blundell
 * 
 */
public class LoaderImageView extends RelativeLayout {

	private static final int COMPLETE = 0;
	private static final int FAILED = 1;
	private Context mContext;
	private Drawable mDrawable;
	private ProgressBar mSpinner;
	private ImageView mImage;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;
	

	/**
	 * This is used when creating the view in XML To have an image load in XML
	 * use the tag
	 * 'image="http://developer.android.com/images/dialog_buttons.png"'
	 * Replacing the url with your desired image Once you have instantiated the
	 * XML view you can call setImageDrawable(url) to change the image
	 * 
	 * @param context
	 * @param attrSet
	 */
	public LoaderImageView(final Context context, final AttributeSet attrSet) {
		super(context, attrSet);
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		final String url = attrSet.getAttributeValue(null, "image");
		if (url != null) {
			instantiate(context, url, -1, -1);
		} else {
			instantiate(context, null, -1, -1);
		}
	}

	public LoaderImageView(final Context context, final AttributeSet attrSet,
			String s) {
		super(context, attrSet);
		final String url = attrSet.getAttributeValue(s, "image");
		if (url != null) {
			instantiate(context, url, -1, -1);
		} else {
			instantiate(context, null, -1, -1);
		}
	}

	/**
	 * This is used when creating the view programatically Once you have
	 * instantiated the view you can call setImageDrawable(url) to change the
	 * image
	 * 
	 * @param context
	 *            the Activity context
	 * @param imageUrl
	 *            the Image URL you wish to load
	 * @param i
	 * @param i
	 */
	public LoaderImageView(final Context context, final String imageUrl, int i,
			int index) {
		super(context);
		instantiate(context, imageUrl, i, index);
	}

	/**
	 * First time loading of the LoaderImageView Sets up the LayoutParams of the
	 * view, you can change these to get the required effects you want
	 * 
	 * @param i
	 */
	private void instantiate(final Context context, final String imageUrl,
			int i, int index) {
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		LayoutParams params = null;
		mContext = context;
		mImage = new ImageView(mContext);
		if (i == 0) {
			if (imageUrl != null) {
				URL url = null;
				try {
					url = new URL(imageUrl);
				} catch (MalformedURLException e) {
					objMobicartLogger.LogExceptionMsg(reqDateFormat
							.format(new Date()), e.getMessage());
				}
				URLConnection ucon = null;
				try {
					ucon = url.openConnection();
				} catch (IOException e) {

					objMobicartLogger.LogExceptionMsg(reqDateFormat
							.format(new Date()), e.getMessage());
				}
				InputStream is = null;
				try {
					is = ucon.getInputStream();
				} catch (IOException e) {

					objMobicartLogger.LogExceptionMsg(reqDateFormat
							.format(new Date()), e.getMessage());
				}
				BufferedInputStream bis = new BufferedInputStream(is);

				ByteArrayBuffer baf = new ByteArrayBuffer(50);
				int current = 0;
				try {
					while ((current = bis.read()) != -1) {
						baf.append((byte) current);
					}
				} catch (IOException e) {

					objMobicartLogger.LogExceptionMsg(reqDateFormat
							.format(new Date()), e.getMessage());
				}
				Bitmap bmp = BitmapFactory.decodeByteArray(baf.toByteArray(),
						0, baf.length());
				MobicartCommonData.bannerImage.add(bmp);

				params = new LayoutParams(bmp.getWidth(), bmp.getHeight());
				params.addRule(RelativeLayout.CENTER_IN_PARENT);

			}
		} else {
			if (i == 2) {
				params = new LayoutParams(MobicartCommonData.bannerImage.get(
						index).getWidth(), MobicartCommonData.bannerImage.get(
						index).getHeight());
				params.addRule(RelativeLayout.CENTER_IN_PARENT);
			} else {
				if (i == 3) {
					if (imageUrl != null) {
						URL url = null;
						try {
							url = new URL(imageUrl);
						} catch (MalformedURLException e) {

							objMobicartLogger.LogExceptionMsg(reqDateFormat
									.format(new Date()), e.getMessage());
						}
						URLConnection ucon = null;
						try {
							ucon = url.openConnection();
						} catch (IOException e) {

							objMobicartLogger.LogExceptionMsg(reqDateFormat
									.format(new Date()), e.getMessage());
						}

						InputStream is = null;
						try {
							is = ucon.getInputStream();
						} catch (IOException e) {

							objMobicartLogger.LogExceptionMsg(reqDateFormat
									.format(new Date()), e.getMessage());
						}
						BufferedInputStream bis = new BufferedInputStream(is);

						ByteArrayBuffer baf = new ByteArrayBuffer(50);
						int current = 0;
						try {
							while ((current = bis.read()) != -1) {
								baf.append((byte) current);
							}
						} catch (IOException e) {

							objMobicartLogger.LogExceptionMsg(reqDateFormat
									.format(new Date()), e.getMessage());
						}
						Bitmap bmp = BitmapFactory.decodeByteArray(baf
								.toByteArray(), 0, baf.length());

						params = new LayoutParams(bmp.getWidth(), bmp
								.getHeight());

						params.addRule(RelativeLayout.CENTER_IN_PARENT);
					}
				} else {
					params = new LayoutParams(
							android.view.ViewGroup.LayoutParams.WRAP_CONTENT,
							android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
					params.addRule(RelativeLayout.CENTER_IN_PARENT);
				}
			}
		}

		mImage.setLayoutParams(params);
		mSpinner = new ProgressBar(mContext);
		LayoutParams spinnerParams = new LayoutParams(
				android.view.ViewGroup.LayoutParams.WRAP_CONTENT,
				android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
		spinnerParams.addRule(RelativeLayout.CENTER_IN_PARENT);
		mSpinner.setLayoutParams(spinnerParams);
		mSpinner.setPadding(40, 40, 40, 40);
		addView(mSpinner);
		addView(mImage);
		if (imageUrl != null) {
			setImageDrawable(imageUrl);
		}
	}

	/**
	 * Set's the view's drawable, this uses the internet to retrieve the image
	 * don't forget to add the correct permissions to your manifest
	 * 
	 * @param imageUrl
	 *            the url of the image you wish to load
	 */
	public void setImageDrawable(final String imageUrl) {

		mDrawable = null;
		mSpinner.setVisibility(View.VISIBLE);
		mImage.setVisibility(View.GONE);
		new Thread() {
			@Override
			public void run() {
				try {
					mDrawable = getDrawableFromUrl(imageUrl);
					imageLoadedHandler.sendEmptyMessage(COMPLETE);
				} catch (MalformedURLException e) {
					imageLoadedHandler.sendEmptyMessage(FAILED);
				} catch (IOException e) {
					imageLoadedHandler.sendEmptyMessage(FAILED);
				}
			};
		}.start();
	}

	/**
	 * Callback that is received once the image has been downloaded
	 */
	private final Handler imageLoadedHandler = new Handler(new Callback() {
		@Override
		public boolean handleMessage(Message msg) {

			switch (msg.what) {
			case COMPLETE:
				mImage.setImageDrawable(mDrawable);
				mImage.setVisibility(View.VISIBLE);
				mSpinner.setVisibility(View.GONE);
				break;
			case FAILED:

			default:

				// Could change image here to a 'failed' image
				// otherwise will just keep on spinning
				break;
			}
			return true;
		}
	});

	/**
	 * Pass in an image url to get a drawable object
	 * 
	 * @return a drawable object
	 * @throws IOException
	 * @throws MalformedURLException
	 */
	private static Drawable getDrawableFromUrl(final String url)
			throws IOException, MalformedURLException {
		return Drawable.createFromStream(
				((java.io.InputStream) new java.net.URL(url).getContent()),
				"name");
	}

	public void setBackgroundDrawable(int wishlistPlaceholder) {
		mImage.setBackgroundResource(wishlistPlaceholder);
	}

	public void setBackgroundDrawable(String imageUrl) {
		URLConnection ucon = null;
		try {
			URL url = new URL(imageUrl);
			ucon = url.openConnection();
		} catch (IOException e) {

			objMobicartLogger.LogExceptionMsg(reqDateFormat
					.format(new Date()), e.getMessage());
		}

		@SuppressWarnings("unused")
		InputStream is = null;
		try {
			is = ucon.getInputStream();
		} catch (IOException e) {

			e.printStackTrace();
		}
		// BufferedInputStream bis = new BufferedInputStream(is);

		try {
			mImage.setBackgroundDrawable(getDrawableFromUrl(imageUrl));
		} catch (MalformedURLException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat
					.format(new Date()), e.getMessage());
		} catch (IOException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat
					.format(new Date()), e.getMessage());
		}
	}
}
