package com.yihg.erp.bo.airticket;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.yihg.airticket.po.AirTicketOrder;
import com.yihg.airticket.po.AirTicketRequest;
import com.yihg.airticket.po.AirTicketResource;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.TourGroup;

public class AirTicketRequestBO {
	private static final Logger log = LoggerFactory.getLogger(AirTicketRequestBO.class);
	private AirTicketRequest po;
	public GroupOrder go;
	private AirTicketResourceBO resourceBo;

	private boolean isArrange=true;
	
	public AirTicketRequestBO(AirTicketRequest po){
		this.po = po;
	}
	
    public Integer getId() {
        return this.po.getId();
    }
    
    public void setGroupOrder(GroupOrder g){
    	this.go=g;
    }
    public GroupOrder getGroupOrder(){
    	if (this.go ==null){
			this.go = new GroupOrder();
			this.go.setTourGroup(new TourGroup());
    	}
    	return this.go;
    }
    public AirTicketRequest getPo(){
    	return this.po;
    }
    public void setResource(AirTicketResource resource){
    	this.po.setResource(resource);
    }
    
    
    public AirTicketResourceBO getResourceBo(){
    	if (this.resourceBo == null){
    		this.resourceBo = new AirTicketResourceBO(this.po.getResource());
    	}
    	return this.resourceBo;
    }
    public void setResourceBo(AirTicketResourceBO resourceBo){
    	this.resourceBo=resourceBo;
    }
    
    public String getOrderNo(){
    	return this.getGroupOrder().getOrderNo();
    }
    public String getGroupCode(){
    	if (this.getGroupOrder().getGroupId()==null){
    		return "N/A";
    	}
    	return this.getGroupOrder().getTourGroup().getGroupCode();
    }
    public String getProduct(){
    	go = this.getGroupOrder();
    	return "【" + go.getProductBrandName() + "】 " 
    			+ go.getProductName() + "<br/>"
    			+ this.getGroupGuestNumber();
    }
    public String getSupplier(){
    	return this.getGroupOrder().getSupplierName();
    }

    public String getGroupDateStart(){
    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    	if (this.getGroupOrder().getTourGroup().getDateStart()==null){
    		return "";
    	}
    	return df.format(this.getGroupOrder().getTourGroup().getDateStart());
    }
    public String getGroupGuestNumber(){
    	GroupOrder o = this.getGroupOrder();
    	if (o==null){return "";}
    	Integer numAdult = o.getNumAdult()==null ? 0 : o.getNumAdult();
    	Integer numChild = o.getNumChild()==null ? 0 : o.getNumChild();
    	Integer numGuide = o.getNumGuide()==null ? 0 : o.getNumGuide();
    	return numAdult +"大 "	+ numChild +"小 " + numGuide+"陪";
    }
    public Integer getGuestNumber(){
    	return po.getGuestNumber();
    }
    
    /**
     * @return string of guestIdList like "301, 302, 310"
     */
    public String getGuestIds(){
    	StringBuffer sb = new StringBuffer();
    	if (po.getOrderList()==null){return "";}
    	for(int i=0; i<po.getOrderList().size(); i++){
    		if (sb.length()==0){
    			sb.append(po.getOrderList().get(i).getGuestId());
    		}else {
    			sb.append(", ").append(po.getOrderList().get(i).getGuestId());
    		}
    	}
    	return sb.toString();
    }
    
    /**
     * @return string of orderIdList like "80,81,82"
     */
    public String getOrderIds(){
    	ArrayList<String> ids = new ArrayList<String>();
    	for (AirTicketOrder o: po.getOrderList()){
    		ids.add(o.getId().toString());
    	}
    	return StringUtils.join(ids, ",");
    }
    
    // for ticket list page.
    public List<GroupOrderGuest> getGuestList(){
    	if (this.go.getGroupOrderGuestList() == null){
    		return null;
    	}
    	Hashtable<Integer, GroupOrderGuest> allGuest = new Hashtable<Integer, GroupOrderGuest>();
    	for (int i=0; i<this.go.getGroupOrderGuestList().size(); i++){
    		GroupOrderGuest tmpGuest = this.go.getGroupOrderGuestList().get(i);
    		allGuest.put(tmpGuest.getId(), tmpGuest);
    	}
    	List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
    	for (int i=0; i<this.po.getOrderList().size(); i++){
    		AirTicketOrder o = this.po.getOrderList().get(i);
   			guestList.add(allGuest.get(o.getGuestId()));
    	}
    	return guestList;
    }
    
    /**
     * @return HashMap<guestId, order>
     */
    public HashMap<Integer, AirTicketOrder> getOrderMap(){
    	HashMap<Integer, AirTicketOrder> orderMap = new HashMap<Integer, AirTicketOrder>();
    	for (int i=0; i<this.po.getOrderList().size(); i++){
    		orderMap.put(this.po.getOrderList().get(i).getGuestId(), 
    				this.po.getOrderList().get(i));
    	}
    	return orderMap;
    }
    
    public Integer getAvailableNumber(){
    	return this.po.getResource().getAvailableNumber();
    }
    
    public String getStatus() {
    	if (this.po.getStatus().equals("ARRANGING")){
    		return "等待票务安排";
    	}else if (this.po.getStatus().equals("REJECTED")){
    		return "退回";
    	}else if (this.po.getStatus().equals("CONFIRMING")){
    		return "已安排，等待确认";
    	}else if (this.po.getStatus().equals("ISSUING")){
    		return "已确认，等待出票";
    	}else if (this.po.getStatus().equals("ISSUED")){
    		return "已出票";
    	}
        return "N/A";
    }
    
    public List<GroupOrderGuest> getGroupOrderGuest(){
    	return this.go.getGroupOrderGuestList();
    }

    public String getOperations(){
    	String arrange = " <a class='button button-rounded button-tinier' href=\"javascript:doAction('arrange.do', "+this.po.getId()+")\">安排（批准）</a> ";
    	String reject = " <a class='button button-rounded button-tinier' href=\"javascript:doAction('reject.do', "+this.po.getId()+")\">退回（不批准）</a> ";
    	String rollback = " <a class='button button-rounded button-tinier' href=\"javascript:doAction('reject.do', "+this.po.getId()+")\">撤销（退回给计调）</a> ";
    	String edit = " <a class='button button-rounded button-tinier' href=\"javascript:toEdit('"+this.getId()+"', '"+this.getOrderNo()+"')\">修改</a> ";
    	String confirm = " <a class='button button-rounded button-tinier' href=\"javascript:toConfirm('"+this.getId()+"', '"+this.getOrderNo()+"')\">核对</a> ";
    	String delete = " <a class='button button-rounded button-tinier' href=\"javascript:doAction('delete.do', "+this.po.getId()+")\">取消申请</a> ";
    	String issue = " <a class='button button-rounded button-tinier' href=\"javascript:doAction('issue.do', "+this.po.getId()+")\">出票（已确认）</a> ";
    	String pickUp = " <a class='button button-rounded button-tinier' href=\"javascript:toPickUp('"+this.po.getId()+"', '"+this.getOrderNo()+"')\">接送机安排</a> ";
    	if (this.po.getStatus().equals("ARRANGING")){
    		if (this.isArrange){
    			return arrange + reject;
    		}else {
    			return delete;
    		}
    	}else if (this.po.getStatus().equals("REJECTED")){
    		if (this.isArrange){
    			return "";
    		}else {
    			return delete;
    		}
    	}else if (this.po.getStatus().equals("CONFIRMING")){
    		if (this.isArrange){
    			return rollback;
    		}else {
    			return confirm + delete;
    		}
    	}else if (this.po.getStatus().equals("ISSUING")){
    		if (this.isArrange){
    			return issue + rollback;
    		}else {
    			return "";
    		}
    	}else if (this.po.getStatus().equals("ISSUED")){
    		if (this.isArrange){
    			return rollback + pickUp;
    		}else {
    			return "";
    		}
    	}
        return "N/A";
    	
    }
    
    public Date getDepDate(){
    	return this.po.getResource().getDepDate();
    }
    
    public boolean isGuestInRequest(Integer guestId){
    	for(int i=0; i<po.getOrderList().size(); i++){
    		if (guestId == po.getOrderList().get(i).getGuestId()){
    			return true;
    		}
    	}
    	return false;
    }
    
    
    public Integer getBizId() {
        return this.po.getBizId();
    }

    public Integer getResourceId() {
        return this.po.getResourceId();
    }

    public String getResourceNumber() {
        return this.po.getResourceNumber();
    }

    public Integer getGroupOrderId() {
        return this.po.getGroupOrderId();
    }

    public Integer getCreaterId() {
        return this.po.getCreaterId();
    }

    public String getCreaterName() {
        return this.po.getCreaterName();
    }

    public Integer getOperatorId() {
        return this.po.getOperatorId();
    }

    public String getOperatorName() {
    	if (this.po.getOperatorName()==null || this.po.getOperatorName().equals("")){
    		return this.po.getCreaterName();
    	}else {
    		return this.po.getOperatorName();
    	}
    }

    public Date getAddTime() {
        return this.po.getAddTime();
    }

    public String getUpdateTime() {
    	DateFormat df = new SimpleDateFormat("MM-dd HH:mm");
    	return df.format(this.po.getUpdateTime());
    }

    public String getComment() {
        return this.po.getComment().replaceAll("\n+", "&nbsp;&nbsp;&nbsp;&nbsp;\n");
    }

	public boolean isArrange() {
		return isArrange;
	}

	public void setArrange(boolean isArrange) {
		this.isArrange = isArrange;
	}
	
}
	