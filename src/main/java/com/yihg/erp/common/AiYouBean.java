package com.yihg.erp.common;

import java.util.HashMap;
import java.util.List;

public class AiYouBean {

	private Integer adult_num;
	private String group_num;
	private Integer child_num;
	private String product_name;
	private String from_city;
	private String group_id;
	private String group_date;
	private String opid;
	private String reseller_contact_name;
	private String reseller_contact_mobile;
	private String reseller_tel;
	private String reseller_fax;
	private String supplier_name;
	private String supplier_tel;
	private String supplier_fax;
	private String room_info;
	private String memo;
	private String reseller_name;
	private String date;

	private String supplier_contact_name;
	private String supplier_contact_mobile;
	private List<String> flight_info;
	private List<HashMap<String, String>> tourists;
	
	private Integer isImport; // 0未导入  1已导入
	
	private String supplierCode;

	public AiYouBean() {
	}

	public Integer getAdult_num() {
		return adult_num;
	}

	public void setAdult_num(Integer adult_num) {
		this.adult_num = adult_num;
	}

	public String getGroup_num() {
		return group_num;
	}

	public void setGroup_num(String group_num) {
		this.group_num = group_num;
	}

	public Integer getChild_num() {
		return child_num;
	}

	public void setChild_num(Integer child_num) {
		this.child_num = child_num;
	}

	public String getProduct_name() {
		return product_name;
	}

	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}

	public String getFrom_city() {
		return from_city;
	}

	public void setFrom_city(String from_city) {
		this.from_city = from_city;
	}

	public String getGroup_id() {
		return group_id;
	}

	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}

	public String getOpid() {
		return opid;
	}

	public void setOpid(String opid) {
		this.opid = opid;
	}

	public String getReseller_contact_name() {
		return reseller_contact_name;
	}

	public void setReseller_contact_name(String reseller_contact_name) {
		this.reseller_contact_name = reseller_contact_name;
	}

	public String getReseller_contact_mobile() {
		return reseller_contact_mobile;
	}

	public void setReseller_contact_mobile(String reseller_contact_mobile) {
		this.reseller_contact_mobile = reseller_contact_mobile;
	}

	public String getReseller_tel() {
		return reseller_tel;
	}

	public void setReseller_tel(String reseller_tel) {
		this.reseller_tel = reseller_tel;
	}

	public String getReseller_fax() {
		return reseller_fax;
	}

	public void setReseller_fax(String reseller_fax) {
		this.reseller_fax = reseller_fax;
	}

	public String getSupplier_name() {
		return supplier_name;
	}

	public void setSupplier_name(String supplier_name) {
		this.supplier_name = supplier_name;
	}

	public String getSupplier_tel() {
		return supplier_tel;
	}

	public void setSupplier_tel(String supplier_tel) {
		this.supplier_tel = supplier_tel;
	}

	public String getSupplier_fax() {
		return supplier_fax;
	}

	public void setSupplier_fax(String supplier_fax) {
		this.supplier_fax = supplier_fax;
	}

	public String getRoom_info() {
		return room_info;
	}

	public void setRoom_info(String room_info) {
		this.room_info = room_info;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getReseller_name() {
		return reseller_name;
	}

	public void setReseller_name(String reseller_name) {
		this.reseller_name = reseller_name;
	}

	public String getSupplier_contact_name() {
		return supplier_contact_name;
	}

	public void setSupplier_contact_name(String supplier_contact_name) {
		this.supplier_contact_name = supplier_contact_name;
	}

	public String getSupplier_contact_mobile() {
		return supplier_contact_mobile;
	}

	public void setSupplier_contact_mobile(String supplier_contact_mobile) {
		this.supplier_contact_mobile = supplier_contact_mobile;
	}

	public void setFlight_info(List<String> flight_info) {
		this.flight_info = flight_info;
	}

	public List<String> getFlight_info() {
		return flight_info;
	}

	public Integer getIsImport() {
		return isImport;
	}

	public void setIsImport(Integer isImport) {
		this.isImport = isImport;
	}

	public String getSupplierCode() {
		return supplierCode;
	}

	public void setSupplierCode(String supplierCode) {
		this.supplierCode = supplierCode;
	}

	public List<HashMap<String, String>> getTourists() {
		return tourists;
	}

	public void setTourists(List<HashMap<String, String>> tourists) {
		this.tourists = tourists;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getGroup_date() {
		return group_date;
	}

	public void setGroup_date(String group_date) {
		this.group_date = group_date;
	}
	

}
