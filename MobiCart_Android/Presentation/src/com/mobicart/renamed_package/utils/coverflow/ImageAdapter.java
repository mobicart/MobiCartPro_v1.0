package com.mobicart.renamed_package.utils.coverflow;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuffXfermode;
import android.graphics.Bitmap.Config;
import android.graphics.PorterDuff.Mode;
import android.graphics.Shader.TileMode;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.Toast;
import android.widget.ImageView.ScaleType;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.R;

/**
 * This Class extending base adapter to create images with same width or height
 * of images which are coming from server.
 * 
 * @author mobicart
 * 
 */
public class ImageAdapter extends BaseAdapter {

	int mGalleryItemBackground;
	private Context mContext;
	private ArrayList<ImageView> mImages;
	private int currentProductPosition;
	private int currentOrder;

	public ImageAdapter(Context c, int currentProductPosition, int currentOrder) {
		this.mContext = c;
		this.currentProductPosition = currentProductPosition;
		this.currentOrder = currentOrder;
		mImages = new ArrayList<ImageView>();
	}

	public boolean createReflectedImages() {
		final int reflectionGap = 4;
		String[] imageUrls = getImagesUrls();
		for (String imageUrl : imageUrls) {
			Bitmap originalImage = BitmapFactory.decodeResource(mContext
					.getResources(), R.drawable.placeholder);
			try {
				/*
				 * originalImage = BitmapFactory.decodeResource(mContext
				 * .getResources(), R.drawable.b);
				 */
				originalImage = BitmapFactory
						.decodeStream((InputStream) new URL(imageUrl)
								.getContent());
			} catch (MalformedURLException e) {
			} catch (IOException e) {
			}
			if (originalImage != null) {
				int width = originalImage.getWidth();
				int height = originalImage.getHeight();
				Matrix matrix = new Matrix();
				matrix.preScale(1, -1);
				// Create a Bitmap with the flip matrix applied to it.
				// We only want the bottom half of the image
				Bitmap reflectionImage = Bitmap.createBitmap(originalImage, 0,
						height / 2, width, height / 2, matrix, false);
				// Create a new bitmap with same width but taller to fit
				// reflection
				Bitmap bitmapWithReflection = Bitmap.createBitmap(width,
						(height + height / 2), Config.ARGB_8888);
				// Create a new Canvas with the bitmap that's big enough for
				// the image plus gap plus reflection
				// Bitmap bitmapWithReflection=reflectionImage;
				Canvas canvas = new Canvas(bitmapWithReflection);
				// Draw in the original image
				canvas.drawBitmap(originalImage, 0, 0, null);
				// Draw in the gap
				Paint deafaultPaint = new Paint();
				canvas.drawRect(0, height, width, height + reflectionGap,
						deafaultPaint);
				// Draw in the reflection
				canvas.drawBitmap(reflectionImage, 0, height + reflectionGap,
						null);
				// Create a shader that is a linear gradient that covers the
				// reflection
				Paint paint = new Paint();
				LinearGradient shader = new LinearGradient(0, originalImage
						.getHeight(), 0, bitmapWithReflection.getHeight()
						+ reflectionGap, 0x70ffffff, 0x00ffffff, TileMode.CLAMP);
				// Set the paint to use this shader (linear gradient)
				paint.setShader(shader);
				// Set the Transfer mode to be porter duff and destination in
				paint.setXfermode(new PorterDuffXfermode(Mode.DST_IN));
				// Draw a rectangle using the paint with our linear gradient
				canvas.drawRect(0, height, width, bitmapWithReflection
						.getHeight()
						+ reflectionGap, paint);
				ImageView imageView = new ImageView(mContext);

				imageView.setImageBitmap(bitmapWithReflection);
				imageView.setLayoutParams(new CoverFlow.LayoutParams(
						bitmapWithReflection.getWidth(), bitmapWithReflection
								.getHeight()));
				imageView.setScaleType(ScaleType.MATRIX);
				mImages.add(imageView);
			}
		}
		return true;
	}

	public int getCount() {
		return mImages.size();
	}

	public Object getItem(int position) {
		return position;
	}

	public long getItemId(int position) {
		return position;
	}

	public View getView(int position, View convertView, ViewGroup parent) {
		try {
			return mImages.get(position);
		} catch (IndexOutOfBoundsException e) {
			Toast.makeText(
					this.mContext,
					MobicartCommonData.keyValues.getString(
							"key.iphone.server.notresp.text",
							"Server not Responding"), Toast.LENGTH_LONG).show();
			return mImages.get(0);
		}

	}

	public float getScale(boolean focused, int offset) {
		return Math.max(0, 1.0f / (float) Math.pow(2, Math.abs(offset)));
	}

	private String[] getImagesUrls() {
		String[] imageUrls = null;
		try {
			if (currentOrder == 1) {

				imageUrls = new String[MobicartCommonData.featuredPrducts.get(
						currentProductPosition).getProductImages().size()];
				for (int i = 0; i < imageUrls.length; i++) {
					imageUrls[i] = MobicartUrlConstants.baseImageUrl.substring(
							0, MobicartUrlConstants.baseImageUrl.length() - 1)
							+ MobicartCommonData.featuredPrducts.get(
									currentProductPosition).getProductImages()
									.get(i).getProductImageCoverFlow();
				}
			} else if (currentOrder == 0) {
				imageUrls = new String[MobicartCommonData.productsList.get(
						currentProductPosition).getProductImages().size()];
				for (int i = 0; i < imageUrls.length; i++) {
					imageUrls[i] = MobicartUrlConstants.baseImageUrl.substring(
							0, MobicartUrlConstants.baseImageUrl.length() - 1)
							+ MobicartCommonData.productsList.get(
									currentProductPosition).getProductImages()
									.get(i).getProductImageCoverFlow();
				}
			} else {
				imageUrls = new String[MobicartCommonData.currentProductCover
						.getProductImages().size()];
				for (int i = 0; i < imageUrls.length; i++) {
					imageUrls[i] = MobicartUrlConstants.baseImageUrl.substring(
							0, MobicartUrlConstants.baseImageUrl.length() - 1)
							+ MobicartCommonData.currentProductCover
									.getProductImages().get(i)
									.getProductImageCoverFlow();
				}
			}
		} catch (NullPointerException e) {
			Toast.makeText(
					this.mContext,
					MobicartCommonData.keyValues.getString(
							"key.iphone.server.notresp.text",
							"Server not Responding"), Toast.LENGTH_LONG).show();
		} catch (IndexOutOfBoundsException e) {
			Toast.makeText(
					this.mContext,
					MobicartCommonData.keyValues.getString(
							"key.iphone.server.notresp.text",
							"Server not Responding"), Toast.LENGTH_LONG).show();
		}
		return imageUrls;
	}
}