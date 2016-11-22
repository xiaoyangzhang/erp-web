package com.yihg.erp.utils;

import java.io.Serializable;

import org.apache.commons.lang.StringUtils;

public class SysConfig implements Serializable {
	
	/**
	* @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	*/
	private static final long serialVersionUID = 1L;

	/**
	 * tfs网关地址
	 */
	private String tfsGwUrl;
	
	/**
	 * 图片服务器地址
	 */
	private String imgServerUrl;
	
	/**
	 * 切图后地址带水印原大小
	 */
	@Deprecated
	private String imgWithWaterUrl;
	/**
	 * 切图服务器地址
	 */
	@Deprecated
	private String imgCutServerUrl;
	/**
	 * 340*340图片地址
	 */
	private String images340Url;
	/**
	 * 200*200图片地址
	 */
	private String images200Url;
	public String getImgServerUrl() {
		return imgServerUrl;
	}
	public void setImgServerUrl(String imgServerUrl) {
		this.imgServerUrl = imgServerUrl;
	}
	public String getImgCutServerUrl() {
		return imgCutServerUrl;
	}
	public void setImgCutServerUrl(String imgCutServerUrl) {
		this.imgCutServerUrl = imgCutServerUrl;
	}
	public String getImages340Url() {		
		return images340Url;
	}
	public void setImages340Url(String images340Url) {
		this.images340Url = images340Url;
	}
	public String getImages200Url() {		
		return images200Url;
	}
	public void setImages200Url(String images200Url) {
		this.images200Url = images200Url;
	}
	public String getImgWithWaterUrl() {
		return imgWithWaterUrl;
	}
	public void setImgWithWaterUrl(String imgWithWaterUrl) {
		this.imgWithWaterUrl = imgWithWaterUrl;
	}
	public String getTfsGwUrl() {
		return tfsGwUrl;
	}
	public void setTfsGwUrl(String tfsGwUrl) {
		this.tfsGwUrl = tfsGwUrl;
	}
	
}
