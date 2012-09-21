package com.mobicart.renamed_package.utils.listeners;

import android.view.MotionEvent;
import android.view.GestureDetector.OnGestureListener;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ViewFlipper;

import com.mobicart.android.model.MobicartCommonData;

/**
 * This class is used for handling view flipper animation from left to right or
 * vice-versa.
 * 
 * @author mobicart
 * 
 */
public class HomeBannersGestureListener implements OnGestureListener {

	private int flipCount;
	private ViewFlipper viewFlipper;

	/**
	 * @param viewFlipper
	 */
	public HomeBannersGestureListener(ViewFlipper viewFlipper) {
		this.viewFlipper = viewFlipper;
		flipCount = 0;

	}

	@Override
	public boolean onDown(MotionEvent e) {
		return false;
	}

	@Override
	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY) {
		if (velocityX > 0 && flipCount > 0) {
			viewFlipper.setInAnimation(inFromLeftAnimation());
			viewFlipper.setOutAnimation(outToRightAnimation());
			viewFlipper.showPrevious();
			flipCount--;
		}
		if (velocityX < 0
				&& flipCount < MobicartCommonData.galleryImages.size() - 1) {
			viewFlipper.setInAnimation(inFromRightAnimation());
			viewFlipper.setOutAnimation(outToLeftAnimation());
			viewFlipper.showNext();
			flipCount++;
		}
		return true;
	}

	@Override
	public void onLongPress(MotionEvent e) {

	}

	@Override
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
			float distanceY) {
		return false;
	}

	@Override
	public void onShowPress(MotionEvent e) {

	}

	@Override
	public boolean onSingleTapUp(MotionEvent e) {
		return false;
	}

	private Animation inFromRightAnimation() {
		Animation inFromRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, +1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		inFromRight.setDuration(500);
		inFromRight.setInterpolator(new AccelerateInterpolator());
		return inFromRight;
	}

	private Animation outToLeftAnimation() {
		Animation outtoLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, -1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		outtoLeft.setDuration(500);
		outtoLeft.setInterpolator(new AccelerateInterpolator());
		return outtoLeft;

	}

	private Animation inFromLeftAnimation() {
		Animation inFromLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, -1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		inFromLeft.setDuration(500);
		inFromLeft.setInterpolator(new AccelerateInterpolator());
		return inFromLeft;
	}

	private Animation outToRightAnimation() {
		Animation outtoRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, +1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		outtoRight.setDuration(500);
		outtoRight.setInterpolator(new AccelerateInterpolator());
		return outtoRight;
	}
}
