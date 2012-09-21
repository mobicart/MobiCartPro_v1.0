package com.mobicart.renamed_package.utils;

import java.util.HashMap;

import android.content.Context;
import android.media.AudioManager;
import android.media.SoundPool;

/**
 * This class control to manage Sound in app and used for Add to cart button on
 * Product detail page..
 * 
 * @author mobicart
 * 
 */
public class SoundManager {

	private SoundPool mSoundPool;
	private HashMap<Integer, Integer> mSoundPoolMap;
	private AudioManager mAudioManager;
	private Context mContext;

	public SoundManager() {
	}

	/**
	 * @param theContext
	 */
	public void initSounds(Context theContext) {
		mContext = theContext;
		mSoundPool = new SoundPool(4, AudioManager.STREAM_MUSIC, 0);
		mSoundPoolMap = new HashMap<Integer, Integer>();
		mAudioManager = (AudioManager) mContext
				.getSystemService(Context.AUDIO_SERVICE);
	}

	/**
	 * @param Index
	 * @param SoundID
	 */
	public void addSound(int Index, int SoundID) {
		mSoundPoolMap.put(1, mSoundPool.load(mContext, SoundID, 1));
	}

	/**
	 * @param index
	 */
	public void playSound(int index) {
		@SuppressWarnings("unused")
		int streamVolume = mAudioManager
				.getStreamVolume(AudioManager.STREAM_MUSIC);
		mSoundPool.play(mSoundPoolMap.get(index), 20, 20, 1, 0, 1f);
	}

	/**
	 * @param index
	 */
	public void playLoopedSound(int index) {
		int streamVolume = mAudioManager
				.getStreamVolume(AudioManager.STREAM_MUSIC);
		mSoundPool.play(mSoundPoolMap.get(index), streamVolume, streamVolume,
				1, -1, 1f);
	}
}