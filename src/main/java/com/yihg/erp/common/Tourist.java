package com.yihg.erp.common;

import java.io.Serializable;

public class Tourist implements Serializable {

	private String tourist_name;
	private String tourist_id;
	private String tourist_id_type; //证件类型
	private String tourist_mobile;

	
	public Tourist() {
	}

	public String getTourist_name() {
		return tourist_name;
	}

	public void setTourist_name(String tourist_name) {
		this.tourist_name = tourist_name;
	}

	public String getTourist_id() {
		return tourist_id;
	}

	public void setTourist_id(String tourist_id) {
		this.tourist_id = tourist_id;
	}

	public String getTourist_mobile() {
		return tourist_mobile;
	}

	public void setTourist_mobile(String tourist_mobile) {
		this.tourist_mobile = tourist_mobile;
	}

	public String getTourist_id_type() {
		return tourist_id_type;
	}

	public void setTourist_id_type(String tourist_id_type) {
		this.tourist_id_type = tourist_id_type;
	}
	
}
