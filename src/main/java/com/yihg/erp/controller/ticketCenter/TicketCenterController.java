package com.yihg.erp.controller.ticketCenter;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.MD5Util;
import com.yihg.mybatis.utility.PageBean;

import com.yimayhd.erpcenter.dal.product.po.TrafficRes;
import com.yimayhd.erpcenter.dal.product.po.TrafficResProduct;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sys.po.SysBizInfo;
import com.yimayhd.erpcenter.facade.ticket.result.WebResult;
import com.yimayhd.erpcenter.facade.ticket.service.TicketCenterFacade;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 机票中心(微信端).
 */
@RestController
@RequestMapping("/ticketCenter")
public class TicketCenterController extends BaseController {
    
    static Logger logger = LoggerFactory.getLogger(TicketCenterController.class);
    
//    private final SysBizInfoService bizInfoService;
//    private final PlatformEmployeeService platformEmployeeService;
//    private final TrafficResService trafficResService;
//    private final TrafficResProductService trafficResProductService;
//    private final ProductInfoService productInfoService;
//    private final ProductRouteService productRouteService;
//    private final ProductRemarkService productRemarkService;
//    private final PlatformOrgService platformOrgService;
//    private final GroupOrderService groupOrderService;
//    private final SpecialGroupOrderService specialGroupOrderService;
//    private final SupplierService supplierService;
//    private final TourGroupService tourGroupService;
    @Autowired
    private TicketCenterFacade ticketCenterFacade;
    
//    @Autowired
//    public TicketCenterController(SysBizInfoService bizInfoService, PlatformEmployeeService platformEmployeeService,
//                                  TrafficResService trafficResService, ProductInfoService productInfoService,
//                                  ProductRouteService productRouteService, ProductRemarkService productRemarkService,
//                                  PlatformOrgService platformOrgService, GroupOrderService groupOrderService,
//                                  SpecialGroupOrderService specialGroupOrderService, SupplierService supplierService,
//                                  TrafficResProductService trafficResProductService, TourGroupService tourGroupService) {
//        this.bizInfoService = bizInfoService;
//        this.platformEmployeeService = platformEmployeeService;
//        this.trafficResService = trafficResService;
//        this.productInfoService = productInfoService;
//        this.productRouteService = productRouteService;
//        this.productRemarkService = productRemarkService;
//        this.platformOrgService = platformOrgService;
//        this.groupOrderService = groupOrderService;
//        this.specialGroupOrderService = specialGroupOrderService;
//        this.supplierService = supplierService;
//        this.trafficResProductService = trafficResProductService;
//        this.tourGroupService = tourGroupService;
//    }
    
    /**
     * 登录机票中心.
     *
     * @param loginName 用户名
     * @param password  密码
     * @param code      商家编码
     * @return 登录人员信息
     */
    @RequestMapping(value = "loginTicketCenter.do")
    public String loginTicketCenter(String loginName, String password, String code) {
//        code = "XTSM";
//
//        if (StringUtils.isBlank(loginName)
//                || StringUtils.isBlank(password)) {
//            return errorJson("用户名或密码不能为空！");
//        }
//
//        SysBizInfo curBizInfo = bizInfoService.getBizInfoByCode(code);
//        if (curBizInfo == null) {
//            return errorJson("当前企业编码不存在！");
//        }
//
//        PlatformEmployeePo platformEmployeePo = platformEmployeeService
//                .getEmployeeByBizIdAndLoginName(curBizInfo.getId(), loginName);
//        if (platformEmployeePo != null) {
//            if (MD5Util.authenticatePassword(platformEmployeePo.getPassword(), password)) {
//                UserSession userSession = new UserSession();
//                platformEmployeePo.setPassword("");
//                userSession.setEmployeeInfo(platformEmployeePo);
//                PlatformOrgPo orgInfo = platformOrgService.getOrgInfo(platformEmployeePo.getBizId(),
//                        platformEmployeePo.getOrgId());
//                userSession.setOrgInfo(orgInfo);
//                Map<String, Object> map = new HashMap<String, Object>();
//                map.put("userSession", userSession);
//                return successJson(map);
//            } else {
//                return errorJson("用户名密码不匹配！");
//            }
//        } else {
//            return errorJson("用户名不存在！");
//        }
        WebResult<Map<String, Object>> webResult = ticketCenterFacade.loginTicketCenter(loginName, password, code);
        if (webResult != null ) {

            if ( webResult.isSuccess()) {
                Map<String, Object> map = webResult.getValue();
                return successJson(map);
            }else {

                return errorJson(webResult.getResultMsg());
            }
        }else {
            return errorJson("系统异常");
        }
    }
    
    /**
     * 机票产品.
     *
     * @param bizId    商家ID
     * @param orgId    权限ID
     * @param dateTime 日期
     * @param pageSize 页数
     * @param page     当前页
     * @return 产品信息
     */
    @RequestMapping(value = "getResProductListToWX.do")
    public String getResProductListToWX(Integer bizId, Integer orgId, String dateTime, Integer pageSize,
                                        Integer page, Integer supplierId) {
        
        PageBean<TrafficResProduct> pageBean = new PageBean<TrafficResProduct>();
        if (page == null) {
            page = 1;
            pageBean.setPage(1);
        } else {
            pageBean.setPage(page);
        }
        if (pageSize == null) {
            pageBean.setPageSize(30);
        } else {
            pageBean.setPageSize(pageSize);
        }
        
        pageBean.setPage(page);
        
        Map<String, Object> pm = new HashMap<String, Object>();
        
        int year = Integer.parseInt(dateTime.split("-")[0]);
        int month = Integer.parseInt(dateTime.split("-")[1]);
        
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, month - 1);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String startTime = sdf.format(cal.getTime());
        
        
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        String endTime = sdf.format(cal.getTime());
        
        pm.put("bizId", bizId.toString());
        pm.put("startTime", startTime);
        pm.put("endTime", endTime);
        pm.put("supplierId", supplierId.toString());
        pageBean.setParameter(pm);
        
        pageBean = ticketCenterFacade.getResProductListToWX(pageBean);
        
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("pageBean", pageBean);
        return successJson(map);
    }
    
    /**
     * 机票产品信息.
     *
     * @param trpId 资源产品ID
     * @param resId 资源ID
     * @return 产品信息
     */
    @RequestMapping(value = "getResProductInfoToWX.do")
    public String getResProductInfoToWX(Integer trpId, Integer resId) {
        
        WebResult<TrafficResProduct> webResult = ticketCenterFacade.getResProductInfoToWX(trpId, resId);
        TrafficResProduct trp =  webResult.getValue();
        trp.setAdultSame(trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()));
        trp.setAdultProxy((trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()))
                .subtract(trp.getAdultProxyPay()));
        trp.setChildSame(trp.getChildSuggestPrice().subtract(trp.getChildSamePay()));
        trp.setChildProxy((trp.getChildSuggestPrice().subtract(trp.getChildSamePay()))
                .subtract(trp.getChildProxyPay()));
        trp.setBabySame(trp.getBabySuggestPrice().subtract(trp.getBabySamePay()));
        trp.setBabyProxy((trp.getBabySuggestPrice().subtract(trp.getBabySamePay())).subtract(trp.getBadyProxyPay()));
        
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("trafficResProduct",trp );
        
        return successJson(map);
    }
    
    /**
     * 产品行程.
     *
     * @param id 产品ID
     * @return 产品行程信息
     */
    @RequestMapping(value = "getProductInfoToWX.do")
    public String getProductInfoToWX(Integer id) {
//        ProductInfoVo productInfoVo = productInfoService.findProductInfoVoById(id);
//        ProductRouteVo productRouteVo = productRouteService.findByProductId(id);
//        ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(id);
//        Map<String, Object> map = new HashMap<String, Object>();
//        map.put("productInfoVo", productInfoVo);
//        map.put("productRouteVo", productRouteVo);
//        map.put("productRemark", productRemark);
        WebResult<Map<String, Object>> webResult = ticketCenterFacade.getProductInfoToWX(id);
        return successJson(webResult.getValue());
    }
    
    /**
     * 预定下单信息.
     *
     * @param trpId 资源产品ID
     * @param resId 资源ID
     * @return 下单信息
     */
    @RequestMapping(value = "getResOrderToWX.do")
    public String getResOrderToWX(Integer trpId, Integer resId) {

        WebResult<TrafficResProduct> webResult = ticketCenterFacade.getResProductInfoToWX(trpId, resId);
        TrafficResProduct trp =  webResult.getValue();
        trp.setAdultSame(trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()));
        trp.setAdultProxy((trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()))
                .subtract(trp.getAdultProxyPay()));
        trp.setChildSame(trp.getChildSuggestPrice().subtract(trp.getChildSamePay()));
        trp.setChildProxy((trp.getChildSuggestPrice().subtract(trp.getChildSamePay()))
                .subtract(trp.getChildProxyPay()));
        trp.setBabySame(trp.getBabySuggestPrice().subtract(trp.getBabySamePay()));
        trp.setBabyProxy((trp.getBabySuggestPrice().subtract(trp.getBabySamePay())).subtract(trp.getBadyProxyPay()));
        
        
        Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("trafficResProduct", trp);
        
        return successJson(map);
    }
    
    /**
     * 验证当前供应商是否有未结清订单.
     *
     * @param bizId      商家ID
     * @param supplierId 供应商ID
     * @param depaDate   出团日期
     * @return 是否存在订单
     */
    @RequestMapping(value = "verifyGroupOrderToWX.do")
    public String verifyGroupOrderToWX(Integer bizId, Integer supplierId, String depaDate) {
        WebResult<String> webResult = ticketCenterFacade.verifyGroupOrderToWX(bizId, supplierId, depaDate);
        if (webResult.isSuccess()) {
            return successJson();
        }else {
            return errorJson(webResult.getResultMsg());
        }
    }
    
    
    /**
     * 保存订单.
     *
     * @param trpId             资源产品ID
     * @param orgId             权限ID
     * @param departureDate     出团日期
     * @param numAdult          成人数
     * @param numChild          儿童数
     * @param numBady           婴儿数
     * @param employeeId        操作人ID
     * @param employeeName      操作人
     * @param bizId             商家ID
     * @param resId             资源ID
     * @param mappingSupplierId 供应商ID
     * @param productId         产品ID
     * @param type              订单类型
     * @param totalPrice        总价格
     * @param adultPrice        成人价格
     * @param childPrice        儿童价格
     * @param badyPrice         婴儿价格
     * @return 保存是否成功
     * @throws ParseException 转换异常
     */
    @RequestMapping(value = "saveResOrderToWX.do")
    public String saveResOrderToWX(Integer trpId, Integer orgId, String departureDate, Integer numAdult,
                                   Integer numChild, Integer numBady, Integer employeeId, String employeeName,
                                   Integer bizId, Integer resId, Integer mappingSupplierId, Integer productId,
                                   Integer type, String totalPrice, String adultPrice, String childPrice,
                                   String badyPrice, String remark)
            throws ParseException {
//        Integer num;
//        Integer orderId = 0;
//        Integer isAdd = 0;
//        GroupOrder go = new GroupOrder();
//        GroupRequirement hotelInfo = new GroupRequirement();
//        hotelInfo.setCountDoubleRoom(0);
//        hotelInfo.setExtraBed(0);
//
//        go.setExtResId(resId);
//        go.setOrderType(0);
//        go.setSupplierId(mappingSupplierId);
//        go.setSupplierName(supplierService.selectBySupplierId(mappingSupplierId).getNameFull());
//        go.setOperatorId(employeeId);
//        go.setOperatorName(employeeName);
//        go.setSaleOperatorId(employeeId);
//        go.setSaleOperatorName(employeeName);
//        go.setNumAdult(numAdult);
//        go.setNumChild(numChild);
//        go.setNumChildBaby(numBady);
//        go.setProductId(productId);
//        go.setTotal(new BigDecimal(totalPrice));
//        go.setRemark(remark);
//
//        ProductInfo productInfo = productInfoService.findProductInfoById(productId);
//
//        go.setProductBrandId(productInfo.getBrandId());
//        go.setProductBrandName(productInfo.getBrandName());
//        go.setProductName(productInfo.getNameCity());
//        go.setType(type);
//
//        go.setExtResConfirmId(null);
//        go.setExtResConfirmName("");
//
//        go.setContactName("");
//        go.setContactTel("");
//        go.setContactMobile("");
//        go.setContactFax("");
//
//        go.setSourceTypeId("-1");
//        go.setProvinceId(null);
//        go.setCityId(null);
//
//
//        TrafficResProduct trafficResProduct = trafficResService.selectTrafficProductInfo(trpId);
//        if (trafficResProduct.getReserveTime() > 0) {
//            go.setExtResCleanTime(trafficResProduct.getReserveTime());
//        }
//
//        num = numAdult + numChild;
//
//        String code = platformOrgService.getCompanyCodeByOrgId(bizId, orgId);
//        go.setOrderNo(code);
//
//        go.setExtResPrepay(((new BigDecimal(numAdult).multiply(trafficResProduct.getAdultMinDeposit()))
//                .add(new BigDecimal(numChild).multiply(trafficResProduct.getChildMinDeposit())))
//                .add(new BigDecimal(numBady).multiply(trafficResProduct.getBadyMinDeposit())));
//
//        go.setDepartureDate(departureDate);
//
//
//        List<GroupOrderPrice> groupOrderPriceList = new ArrayList<GroupOrderPrice>();
//
//        GroupOrderPrice gpAdult = new GroupOrderPrice();
//        gpAdult.setMode(0);
//        gpAdult.setItemId(137);
//        gpAdult.setItemName("成人");
//        gpAdult.setNumTimes(1D);
//        gpAdult.setPriceLockState(1);
//
//        if (numAdult > 0) {
//            gpAdult.setNumPerson(Double.parseDouble(numAdult.toString()));
//            gpAdult.setUnitPrice(Double.parseDouble(adultPrice));
//            gpAdult.setTotalPrice((Double.parseDouble(adultPrice) * numAdult));
//            gpAdult.setRemark("");
//
//            groupOrderPriceList.add(gpAdult);
//        }
//
//        GroupOrderPrice gpChild = new GroupOrderPrice();
//        gpChild.setMode(0);
//        gpChild.setItemId(137);
//        gpChild.setItemName("成人");
//        gpChild.setNumTimes(1D);
//        gpChild.setPriceLockState(1);
//        if (numChild > 0) {
//            gpChild.setNumPerson(Double.parseDouble(numAdult.toString()));
//            gpChild.setUnitPrice(Double.parseDouble(childPrice));
//            gpChild.setTotalPrice((Double.parseDouble(childPrice) * numAdult));
//            gpChild.setRemark("");
//
//            groupOrderPriceList.add(gpChild);
//        }
//
//        GroupOrderPrice gpBady = new GroupOrderPrice();
//        gpBady.setMode(0);
//        gpBady.setItemId(137);
//        gpBady.setItemName("成人");
//        gpBady.setNumTimes(1D);
//        gpBady.setPriceLockState(1);
//        if (numBady > 0) {
//            gpBady.setNumPerson(Double.parseDouble(numAdult.toString()));
//            gpBady.setUnitPrice(Double.parseDouble(badyPrice));
//            gpBady.setTotalPrice((Double.parseDouble(badyPrice) * numBady));
//            gpBady.setRemark("");
//
//            groupOrderPriceList.add(gpBady);
//        }
//
//
//        SpecialGroupOrderVO vo = new SpecialGroupOrderVO();
//        vo.setGroupOrder(go);
//        vo.setHotelInfo(hotelInfo);
//        vo.setGroupOrderPriceList(groupOrderPriceList);
//
//        //保存订单
//        orderId = specialGroupOrderService.saveOrUpdateSpecialOrderInfo(vo, employeeId, employeeName, bizId);
//
//        //减资源库存
//        TrafficResStocklog trafficResStocklog = new TrafficResStocklog();
//        // 全款
//        trafficResStocklog.setAdjustAction(TRAFFICRES_STOCK_ACTION.ORDER_SOLD.toString());
//        trafficResStocklog.setOrderId(orderId);
//        trafficResStocklog.setAdjustNum(num);
//        trafficResStocklog.setResId(vo.getGroupOrder().getExtResId());
//        trafficResStocklog.setAdjustTime(new Date());
//        trafficResStocklog.setUserId(employeeId);
//        trafficResStocklog.setUserName(employeeName);
//
//        if (isAdd == 1) {
//            trafficResService.insertTrafficResStocklog(trafficResStocklog); //Stock表
//        } else {
//            trafficResService.updateTrafficResStockLogByOrderId(trafficResStocklog);
//        }
//
//        //更新产品已售数量
//        if (null != trafficResProduct) {
//            Integer sumPerson = groupOrderService.selectSumPersonByProductId(trafficResProduct.getResId(),
//                    trafficResProduct.getProductCode(), vo.getGroupOrder().getDepartureDate());
//            trafficResProduct.setNumSold(sumPerson);
//            trafficResService.updateNumSoldById(trafficResProduct);
//        }
//
//        //更新资源的库存数量
//        trafficResService.updateStockOrStockDisable(vo.getGroupOrder().getExtResId());
//        ticketCenterFacade.save
//        return successJson("groupId", orderId + "");
    }
    
    
    /**
     * 订单列表.
     *
     * @param bizId       商家ID
     * @param extResState 订单状态
     * @param supplierId  供应商ID
     * @return 订单列表
     */
    @RequestMapping(value = "getGroupOrderToWX.do")
    public String getGroupOrderToWX(Integer bizId, Integer extResState, Integer supplierId) {
        
        if (extResState == null) {
            extResState = 1;
        }
        
        WebResult<List<GroupOrder>> webResult = ticketCenterFacade.getGroupOrderToWX(bizId, extResState, supplierId);
        List<GroupOrder> list = webResult.getValue();
        for (GroupOrder order : list) {
            if (order.getDateLatest() == null) {
                order.setDateLatest("");
            }
            
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("groupOrder", list);
        
        return successJson(map);
    }
    
    /**
     * 订单详情.
     *
     * @param bizId        商家ID
     * @param groupOrderId 订单ID
     * @return 订单详细信息
     */
    @RequestMapping(value = "getGroupOrderDetailToWX.do")
    public String getGroupOrderDetailToWX(Integer bizId, Integer groupOrderId) {
        
//        GroupOrder groupOrder = groupOrderService.findOrderById(bizId, groupOrderId);
//        if (groupOrder.getRemark() == null) {
//            groupOrder.setRemark("");
//        }
//
//        TrafficRes tr = trafficResService.selectTrafficResAndLineInfoById(groupOrder.getExtResId());
//
//        TrafficResProduct trp = trafficResService.selectTrafficProductInfoByProductCode(groupOrder.getProductId(),
//                groupOrder.getExtResId());
//
//        trp.setAdultSame(trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()));
//        trp.setAdultProxy((trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()))
//                .subtract(trp.getAdultProxyPay()));
//        trp.setChildSame(trp.getChildSuggestPrice().subtract(trp.getChildSamePay()));
//        trp.setChildProxy((trp.getChildSuggestPrice().subtract(trp.getChildSamePay()))
//                .subtract(trp.getChildProxyPay()));
//        trp.setBabySame(trp.getBabySuggestPrice().subtract(trp.getBabySamePay()));
//        trp.setBabyProxy((trp.getBabySuggestPrice().subtract(trp.getBabySamePay())).subtract(trp.getBadyProxyPay()));
//
//        String confirmDate = "";
//        if (groupOrder.getGroupId() != null) {
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//            Date date = new Date(tourGroupService.selectByPrimaryKey(groupOrder.getGroupId()).getCreateTime());
//
//            confirmDate = sdf.format(date);
//        }
//
//        Map<String, Object> map = new HashMap<String, Object>();
//
//        map.put("trafficResProduct", trp);
//        map.put("groupOrder", groupOrder);
//        map.put("tr", tr);
//        map.put("confirmDate", confirmDate);
        WebResult<Map<String, Object>> webResult = ticketCenterFacade.getGroupOrderDetailToWX(bizId, groupOrderId);
        return successJson(webResult.getValue());
    }
    
    /**
     * 取消订单.
     *
     * @param groupOrderId 订单ID
     * @return 是否成功
     */
    @RequestMapping(value = "cancelOrder.do")
    public String cancelOrder(Integer groupOrderId) {
        
//        TrafficResStocklog trafficResStocklog = new TrafficResStocklog();
//        trafficResStocklog.setAdjustState(2);
//
//        GroupOrder order = groupOrderService.selectByPrimaryKey(groupOrderId);
//
//        Integer extResState = 2;
//
//        //更新group_order表
//        order.setExtResState(extResState);
//        order.setState(0);
//        int nums = groupOrderService.loadUpdateExtResState(order);
//
//        //若状态改为已确认，则需要更改 traffic_res_stocklog 预留订单状态为已确认
//        trafficResStocklog.setResId(order.getExtResId());
//        trafficResStocklog.setOrderId(order.getId());
//        trafficResService.updateStockLog_AdjustState(trafficResStocklog);
//
//        //更新产品已售数量
//        TrafficResProduct trafficResProduct = trafficResService.selectTrafficProductInfoByProductCode(
//                order.getProductId(), order.getExtResId());
//        if (null != trafficResProduct) {
//            Integer sumPerson = groupOrderService.selectSumPersonByProductId(trafficResProduct.getResId(),
//                    trafficResProduct.getProductCode(), order.getDepartureDate());
//            trafficResProduct.setNumSold(sumPerson);
//            trafficResService.updateNumSoldById(trafficResProduct);
//        }
//
//        //更新库存
//        trafficResService.updateStockOrStockDisable(order.getExtResId());
//
//        Map<String, Object> map = new HashMap<String, Object>();
//        map.put("success", nums);
        WebResult<Map<String, Object>> webResult = ticketCenterFacade.cancelOrder(groupOrderId);
        return successJson(webResult.getValue());
    }
    
    /**
     * 根据日期显示日历产品.
     *
     * @param bizId    商家ID
     * @param dateTime 时间 eg.2017-01
     * @return 日期对应产品信息
     */
    @RequestMapping(value = "getProductInfoByYearToWX.do")
    public String getProductInfoByYearToWX(Integer bizId, String dateTime) {
        int year = Integer.parseInt(dateTime.split("-")[0]);
        int month = Integer.parseInt(dateTime.split("-")[1]);
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, month - 1);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String startTime = sdf.format(cal.getTime());
        
        
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        String endTime = sdf.format(cal.getTime());
        WebResult<List<TrafficRes>> webResult = ticketCenterFacade.getProductInfoByYearToWX(bizId, startTime, endTime);
        List<TrafficRes> list = webResult.getValue();
        Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("trafficResList", list);
        return successJson(map);
    }
    
    /**
     * 根据日期显示产品列表
     *
     * @param bizId    商家ID
     * @param dateTime 日期 eg.2017-01-10
     * @param trId     资源ID
     * @return 产品列表
     */
    @RequestMapping(value = "getProductInfoListByTimeToWX.do")
    public String getProductInfoListByTimeToWX(Integer bizId, String dateTime, Integer trId, Integer supplierId) {
        
        WebResult<List<TrafficResProduct>> webResult = ticketCenterFacade.getProductInfoListByTimeToWX(bizId, dateTime, trId,
                supplierId);
        List<TrafficResProduct> list = webResult.getValue();
        Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("trafficResProductList", list);
        return successJson(map);
    }
}
