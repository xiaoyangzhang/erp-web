package com.yihg.erp.common;

import java.util.List;

public class AiYouOpBillDetailBean {

    private String acomInfo;
    private Integer adultNum;
    private String bid;
    private Integer childrenNum;
    private Double childPrice;
    private String shuttleInfo;
    private String startDate;
    private String groupNum;
    private String memo;
    private List<AiYouMembersBean> members;

    public List<AiYouMembersBean> getMembers() {
        return members;
    }

    public void setMembers(List<AiYouMembersBean> members) {
        this.members = members;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getChildPrice() {
        return childPrice;
    }

    public void setChildPrice(Double childPrice) {
        this.childPrice = childPrice;
    }

    private Double price;


    private String productName;

    public String getAcomInfo() {
        return acomInfo;
    }

    public Integer getAdultNum() {
        return adultNum;
    }

    public String getBid() {
        return bid;
    }

    public Integer getChildrenNum() {
        return childrenNum;
    }

    public String getStartDate() {
        return startDate;
    }

    public String getGroupNum() {
        return groupNum;
    }

    public String getMemo() {
        return memo;
    }

    public String getProductName() {
        return productName;
    }

    public String getShuttleInfo() {
        return shuttleInfo;
    }

    public void setAcomInfo(String acomInfo) {
        this.acomInfo = acomInfo;
    }

    public void setAdultNum(Integer adultNum) {
        this.adultNum = adultNum;
    }

    public void setBid(String bid) {
        this.bid = bid;
    }

    public void setChildrenNum(Integer childrenNum) {
        this.childrenNum = childrenNum;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public void setGroupNum(String groupNum) {
        this.groupNum = groupNum;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setShuttleInfo(String shuttleInfo) {
        this.shuttleInfo = shuttleInfo;
    }
}
