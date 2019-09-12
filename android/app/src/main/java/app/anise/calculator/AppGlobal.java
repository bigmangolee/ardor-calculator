package app.anise.calculator;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.text.TextUtils;

import app.anise.lib.crypto.MD5;

/**
 * 应用程序全局变量. 该全局变量会则前后台进程中使用，这两个进程的值可能是不一致的，则初始化和获取值时需要注意.
 */
public class AppGlobal {
	private static final String TAG = AppGlobal.class.getSimpleName();
	private static AppGlobal sInstance;

	private Context applicationContext;

	private Handler handler;

	private AppEnvironment mAppEnvironment = null;

	private String treasuresKey;

	private static final String exportKey = "app.anise.calculator";

	private boolean isPrivateShow = false;
	/**
	 * 
	 */
	private AppGlobal() {
	}

	public static AppGlobal getInstance() {
		if (sInstance == null) {
			synchronized (AppGlobal.class) {
				if (sInstance == null) {
					sInstance = new AppGlobal();
				}
			}
		}
		return sInstance;
	}

	public void setApplicationContext(Context applicationContext) {
		if (applicationContext instanceof Activity){
			this.applicationContext = ((Activity)applicationContext).getApplicationContext();
		}else{
			this.applicationContext = applicationContext;
		}
		if(handler == null){
			handler = new Handler();
		}

	}

	public Context getApplicationContext() {
		return applicationContext;
	}

	public Handler getHandler() {
		return handler;
	}


	public AppEnvironment getAppEnvironment(){
		if(mAppEnvironment == null){
			String CHANNEL_ID = getMetaData("TD_CHANNEL_ID");
			if("DEV".equalsIgnoreCase(CHANNEL_ID)){
				mAppEnvironment = AppEnvironment.DEV;
			}else if("STG".equalsIgnoreCase(CHANNEL_ID)){
				mAppEnvironment = AppEnvironment.STG;
			}else if("PRE".equalsIgnoreCase(CHANNEL_ID)){
				mAppEnvironment = AppEnvironment.PRE;
			}else {
				mAppEnvironment = AppEnvironment.PRD;
			}
		}
		return mAppEnvironment==null? AppEnvironment.PRD:mAppEnvironment;
	}

	public String getMetaData(String key){
		return getMetaData(key,false,0);
	}

	public String getMetaData(String key, boolean isInteger, int def){
		if(TextUtils.isEmpty(key)){
			return null;
		}
		ApplicationInfo info = null;
		try {
			info = applicationContext.getPackageManager().getApplicationInfo(applicationContext.getPackageName(), PackageManager.GET_META_DATA);
		} catch (PackageManager.NameNotFoundException e) {
			e.printStackTrace();
		}
		if(isInteger){
			return ""+info.metaData.getInt(key,def);
		}else{
			return info.metaData.getString(key);
		}
	}

	public String getTreasuresKey() {
		return treasuresKey;
	}

	public void setTreasuresKey(String treasuresKey) {
		this.treasuresKey = treasuresKey;
	}

	public static String getExportKey() {
		return MD5.makeMD5(exportKey);
	}

	public boolean isPrivateShow() {
		return isPrivateShow;
	}

	public void setPrivateShow(boolean privateShow) {
		isPrivateShow = privateShow;
	}

	public enum AppEnvironment{
		DEV,
		STG,
		PRE,
		PRD
	}
}
