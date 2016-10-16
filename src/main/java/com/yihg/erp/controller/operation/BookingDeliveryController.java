package com.yihg.erp.controller.operation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.util.NumberUtil;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.OpenPlatformConstannt;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.images.utils.DateUtil;
import com.yihg.erp.utils.MD5Util;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingDeliveryPriceService;
import com.yihg.operation.api.BookingDeliveryService;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingDelivery;
import com.yihg.operation.po.BookingDeliveryOrder;
import com.yihg.operation.po.BookingDeliveryPrice;
import com.yihg.operation.po.BookingDeliveryRoute;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingSupplier;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.operation.vo.BookingDeliveryStatics;
import com.yihg.operation.vo.BookingGroup;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupOrderTransportService;
import com.yihg.sales.api.GroupRequirementService;
import com.yihg.sales.api.GroupRouteService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.AssistantGroupOrderGuest;
import com.yihg.sales.po.AssistantGroupRoute;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderPrintPo;
import com.yihg.sales.po.GroupOrderTransport;
import com.yihg.sales.po.GroupRequirement;
import com.yihg.sales.po.GroupRoute;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.po.TransferOrder;
import com.yihg.sales.po.TransferOrderFamily;
import com.yihg.sales.po.TransferOrderGuest;
import com.yihg.sales.po.TransferOrderPrice;
import com.yihg.sales.po.TransferOrderRoute;
import com.yihg.sales.vo.AssistantGroupVO;
import com.yihg.sales.vo.GroupRouteVO;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.sales.vo.TransferOrderVO;
import com.yihg.supplier.api.SupplierImgService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.SysBizInfo;

@Controller
@RequestMapping("/booking")
public class BookingDeliveryController extends BaseController {
    
    @Autowired
    private TourGroupService tourGroupService;
    @Autowired
    private GroupRouteService routeService;
    @Autowired
    private GroupOrderService orderService;
    @Autowired
    private SupplierService supplierSerivce;
    @Autowired
    private BookingDeliveryService deliveryService;
    @Autowired
    private DicService dicService;
    @Autowired
    private SupplierImgService imgService;
    @Autowired
    private SysConfig config;
    @Resource
    private BizSettingCommon bizSettingCommon;
    @Autowired
    private BookingSupplierService bSupplierService;
    @Autowired
    private BookingSupplierDetailService detailService;
    @Autowired
    private BookingGuideService guideService;
    @Autowired
    private GroupOrderGuestService guestService;
    @Autowired
    private GroupRequirementService groupRequirementService;
    @Autowired
    private GroupOrderTransportService groupOrderTransportService;
    @Autowired
    private BookingDeliveryPriceService bookingDeliveryPriceService;
    @Autowired
    private PlatformOrgService orgService;
    @Autowired
    private PlatformEmployeeService platformEmployeeService;
    
    @ModelAttribute
    public void getOrgAndUserTreeJsonStr(ModelMap model, HttpServletRequest request) {
        model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
        model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
    }
    
    @RequestMapping("toDeliveryPriceList.htm")
    public String toDeliveryPriceList(HttpServletRequest request, ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model,bizId);
        return "/operation/delivery/supplierList";
    }
    
    @RequestMapping("toDeliveryPriceTable.do")
    public String toDeliveryPriceTable(HttpServletRequest request, BookingDeliveryPrice bookingDeliveryPrice, Model model) {
        PageBean<BookingDeliveryPrice> pageBean = new PageBean<BookingDeliveryPrice>();
        pageBean.setPage(bookingDeliveryPrice.getPage());
        pageBean.setPageSize(bookingDeliveryPrice.getPageSize() == null ? Constants.PAGESIZE : bookingDeliveryPrice.getPageSize());
        String carInfo = (String) WebUtils.getQueryParamters(request).get("carInfo");
        if (StringUtils.isNotBlank(carInfo)) {
            List<Integer> groupIds = bSupplierService.getGroupIdByCarInfo(carInfo);
            if (groupIds != null && groupIds.size() > 0) {
                String groupIdStr = groupIds.toString().substring(1, groupIds.toString().length() - 1);
                bookingDeliveryPrice.setGroupIds(groupIdStr);
            }
        }
        Map paramters = WebUtils.getQueryParamters(request);
        if (StringUtils.isBlank((String) paramters.get("saleOperatorIds")) && StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
            Set<Integer> set = new HashSet<Integer>();
            String[] orgIdArr = paramters.get("orgIds").toString().split(",");
            for (String orgIdStr : orgIdArr) {
                set.add(Integer.valueOf(orgIdStr));
            }
            set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
            String salesOperatorIds = "";
            for (Integer usrId : set) {
                salesOperatorIds += usrId + ",";
            }
            if (!salesOperatorIds.equals("")) {
                bookingDeliveryPrice.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
                //paramters.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length()-1));
            }
        }
        pageBean.setParameter(bookingDeliveryPrice);
        Map<String, Object> sum = bookingDeliveryPriceService.getSupplierPriceTotal(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
        //Map<String, Object> sumPerson = bookingDeliveryPriceService.getSupplierPriceTotalPerson(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
        pageBean = bookingDeliveryPriceService.getSupplierPriceListPage(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
        model.addAttribute("sum", sum);
        //model.addAttribute("sumPerson", sumPerson) ;
        model.addAttribute("page", pageBean);
        model.addAttribute("prices", pageBean.getResult());
        return "/operation/delivery/supplierTable";
    }
    
    @RequestMapping("deliveryList.htm")
    @RequiresPermissions(PermissionConstants.JDGL_ANGENCY)
    public String deliveryList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
        model.addAttribute("supplierType", Constants.LOCALTRAVEL);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
        return "/operation/delivery/delivery-list";
    }
    
    
    @RequestMapping("deliveryList.do")
    @RequiresPermissions(PermissionConstants.JDGL_ANGENCY)
    public String deliveryList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
        PageBean pageBean = new PageBean();
        if (group.getPage() == null) {
            pageBean.setPage(1);
        } else {
            pageBean.setPage(group.getPage());
        }
        if (group.getPageSize() == null) {
            pageBean.setPageSize(Constants.PAGESIZE);
        } else {
            pageBean.setPageSize(group.getPageSize());
        }
        
        //如果人员为空并且部门不为空，则取部门下的人id
        if (StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())) {
            Set<Integer> set = new HashSet<Integer>();
            String[] orgIdArr = group.getOrgIds().split(",");
            for (String orgIdStr : orgIdArr) {
                set.add(Integer.valueOf(orgIdStr));
            }
            set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
            String salesOperatorIds = "";
            for (Integer usrId : set) {
                salesOperatorIds += usrId + ",";
            }
            if (!salesOperatorIds.equals("")) {
                group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
            }
        }
        
        //group.setSupplierType(Constants.GUIDE);
        group.setBizId(WebUtils.getCurBizId(request));
        pageBean.setParameter(group);
        
        pageBean = tourGroupService.getLocalTravelAngencyGroupList(pageBean, group, WebUtils.getDataUserIdSet(request));
        
        model.addAttribute("pageBean", pageBean);
        model.addAttribute("supplierType", group.getSupplierType());
        return "/operation/delivery/delivery-list-table";
    }
    
    /**
     * 地接社预定列表
     *
     * @param request
     * @param response
     * @param model
     * @param gid
     * @return
     */
    @RequestMapping("deliveryBookingList.htm")
    @RequiresPermissions(PermissionConstants.JDGL_ANGENCY)
    public String deliveryOrderList(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer gid) {
        List<BookingDelivery> list = deliveryService.getDeliveryListByGroupId(gid);
        if (list != null && list.size() > 0) {
            for (BookingDelivery delivery : list) {
                delivery.setPriceList(bookingDeliveryPriceService.getPriceListByBookingId(delivery.getId()));
            }
        }
        
        model.addAttribute("list", list);
        model.addAttribute("deliverBroker", getDeliveryBrokerUser(request));
        return "/operation/delivery/delivery-booking-list";
    }
    
    /**
     * 与deliveryBookingList.htm功能类似，为预定安排总页面准备
     * 计调管理-预定安排
     *
     * @param request
     * @param response
     * @param model
     * @param gid
     * @return
     */
    @RequestMapping("groupDeliveryBookingList.htm")
    @RequiresPermissions(PermissionConstants.JDGL_YDAP)
    public String groupDeliveryBookingList(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer gid) {
        List<BookingDelivery> list = deliveryService.getDeliveryListByGroupId(gid);
        if (list != null && list.size() > 0) {
            for (BookingDelivery delivery : list) {
                delivery.setPriceList(bookingDeliveryPriceService.getPriceListByBookingId(delivery.getId()));
            }
        }
        
        model.addAttribute("list", list);
        model.addAttribute("groupId", gid);
        model.addAttribute("groupCanEdit", tourGroupService.checkGroupCanEdit(gid));
        model.addAttribute("deliverBroker", getDeliveryBrokerUser(request));
        return "/operation/delivery/group-delivery-booking-list";
    }
    
    @RequestMapping("delivery.htm")
    //@RequiresPermissions(PermissionConstants.JDGL_ANGENCY)
    public String deliveryEdit(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer gid, Integer bid) {
        loadAngencyInfo(request, model, gid, bid);
        return "/operation/delivery/delivery-edit";
    }
    
    @RequestMapping("viewDelivery.htm")
    //@RequiresPermissions(PermissionConstants.JDGL_ANGENCY)
    public String deliveryView(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer gid, Integer bid) {
        // 添加新价格项目类型字典
        loadAngencyInfo(request, model, gid, bid);
        model.addAttribute("view", 1);
        return "/operation/delivery/delivery-edit";
    }
    
    private void loadAngencyInfo(HttpServletRequest request, ModelMap model, Integer gid, Integer bid) {
        int bizId = WebUtils.getCurBizId(request);
        List<DicInfo> typeList = dicService
                .getListByTypeCode(BasicConstants.XMFY_DJXM, bizId);
        model.addAttribute("typeList", typeList);
        
        TourGroup groupInfo = tourGroupService.selectByPrimaryKey(gid);
        List<GroupRoute> routeList = routeService.selectByGroupId(gid);
        if (groupInfo.getGroupMode() < 1) {
            List<GroupOrder> orderList = orderService.selectOrderByGroupId(gid);
            if (orderList != null && orderList.size() > 0) {
                for (GroupOrder order : orderList) {
                    SupplierInfo supplierInfo = supplierSerivce.selectBySupplierId(order.getSupplierId());
                    if (supplierInfo != null) {
                        order.setSupplierName(supplierInfo.getNameFull());
                    }
                }
            }
            model.addAttribute("orderList", orderList);
        }
        model.addAttribute("group", groupInfo);
        /*if(groupInfo!=null && routeList!=null){
            for(GroupRoute route : routeList){
				route.setGroupDate(DateUtils.addDays(groupInfo.getDateStart(), route.getDayNum()));
			}
		}*/
        model.addAttribute("routeList", routeList);
        if (bid != null) {
            BookingDelivery delivery = deliveryService.getBookingInfoById(bid);
            model.addAttribute("booking", delivery);
        }
    }
    
    /**
     * @param request
     * @param response
     * @param model
     * @param booking
     * @return
     */
    @RequestMapping(value = "saveBooking.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveBooking(
            HttpServletRequest request,
            HttpServletResponse response,
            ModelMap model,
            String booking) {
        BookingDelivery bookingDelivery = JSON.parseObject(booking, BookingDelivery.class);
        if (!tourGroupService.checkGroupCanEdit(bookingDelivery.getGroupId())) {
            return errorJson("该团已审核或封存，不允许修改该信息");
        }
        if (bookingDelivery.getId() == null) {
            PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
            bookingDelivery.setUserId(userInfo.getEmployeeId());
            bookingDelivery.setUserName(userInfo.getName());
            bookingDelivery.setStateBooking(0);
            bookingDelivery.setStateFinance(0);
            bookingDelivery.setBookingDate(new Date());
            bookingDelivery.setCreateTime(System.currentTimeMillis());
        }
        int id = deliveryService.saveBooking(bookingDelivery);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("groupId", bookingDelivery.getGroupId());
        map.put("bookingId", id);
        
        // 推送信息给接口中心
//        List<GroupOrder> groupOrder = orderService
//                .selectOrderByGroupId(bookingDelivery.getGroupId());
//        TourGroup tourGroup = tourGroupService.selectByPrimaryKey(bookingDelivery.getGroupId());
//        BookingDelivery bd = deliveryService.getBookingInfoById(bookingDelivery.getId());
//        TransferOrderVO orderVo = new TransferOrderVO();
//        TransferOrder transferOrder = new TransferOrder();
//        List<TransferOrderFamily> familys = new ArrayList<TransferOrderFamily>();
//        List<TransferOrderGuest> guests = new ArrayList<TransferOrderGuest>();
//        List<TransferOrderPrice> prices = new ArrayList<TransferOrderPrice>();
//        List<TransferOrderRoute> routes = new ArrayList<TransferOrderRoute>();
//        
//        orderVo.setTransferOrder(transferOrder);
//        orderVo.setFamilys(familys);
//        orderVo.setGuests(guests);
//        orderVo.setPrices(prices);
//        orderVo.setRoutes(routes);
//        
//        // 给TransferOrder赋值
//        transferOrder.setAppId("");
//        transferOrder.setApiMethod("");
//        // t.setSupplierId(geoupOrder.getSupplierId());
//        // t.setSupplierName(geoupOrder.getSupplierName());
//        transferOrder.setFromOrderId(bd.getId());
//        transferOrder.setSendUserName(bd.getUserName());
//        transferOrder.setSendUserMobile("");
//        transferOrder.setSendUserTel("");
//        transferOrder.setSendUserFax("");
//        transferOrder.setBizId(WebUtils.getCurBizId(request));
//        transferOrder.setOrderId(0);
//        transferOrder.setOrderCodeSend(tourGroup.getGroupCode());
//        transferOrder.setOrderCodeReceive("");// 接收方订单号
//        transferOrder.setOrderProductName(tourGroup.getProductName());
//        // t.setSupplierName(bookingDelivery.getSupplierName());
//        // t.setSupplierId(bookingDelivery.getSupplierId());
//        transferOrder.setSupplierUserName(bd.getContact());
//        transferOrder.setSupplierUserMobile(bd.getContactMobile());
//        transferOrder.setSupplierUserTel(bd.getContactTel());
//        transferOrder.setSupplierUserFax(bd.getContactFax());
//        transferOrder.setDaynum(tourGroup.getDaynum());
//        transferOrder.setDateStart(tourGroup.getDateStart());
//        transferOrder.setDateEnd(tourGroup.getDateEnd());
//        
//        transferOrder.setPersonAdult(bd.getPersonAdult());
//        transferOrder.setPersonChild(bd.getPersonChild());
//        transferOrder.setPersonGuide(bd.getPersonGuide());
//        transferOrder.setRemark(bd.getRemark());
//        transferOrder.setRemarkService("");
//        transferOrder.setTotal(tourGroup.getTotal());
//        transferOrder.setStateReceive((byte) 0);
//        transferOrder.setStateUpdate((byte) 1);
//        transferOrder.setTimeReceive(new Date());
//        transferOrder.setTimeCreate(new Date());
//        transferOrder.setTimeUpdate(new Date());
//        
//        //TransferOrderFamily
//        if (tourGroup.getGroupMode() <= 0) { // 散客团
//            if (groupOrder != null && groupOrder.size() > 0) {
//                for (GroupOrder go : groupOrder) {
//                    TransferOrderFamily family = new TransferOrderFamily();
//                    List<GroupOrderTransport> orderTransports = groupOrderTransportService
//                            .selectByGroupId(go.getId());
//                    family.setId(0);
//                    family.setOrderId(0);
//                    family.setFromOrderId(bd.getId());
//                    family.setFromOrderFamilyId(go.getId());
//                    family.setLeaderName(go.getReceiveMode());
//                    family.setPersonAdult(go.getNumAdult());
//                    family.setPersonChild(go.getNumChild());
//                    family.setHotelLevel(go.getHotelLevels());
//                    family.setHotelNums(go.getHotelNums());
//                    // 省外（长线）－接机信息
//                    family.setTransportArrival(getAirInfo(orderTransports, 0));
//                    // 省内（短线）－接送信息
//                    family.setTransportMiddle(getSourceType(orderTransports));
//                    // '接送信息：省外（长线）－送机信息',
//                    family.setTransportLeave(getAirInfo(orderTransports, 1));
//                    family.setRemark(go.getRemark());
//                    familys.add(family);
//                    
//                    // 给guestList赋值
//                    List<GroupOrderGuest> gu = guestService.selectByOrderId(go.getId());
//                    if (gu != null && gu.size() > 0) {
//                        for (GroupOrderGuest item : gu) {
//                            TransferOrderGuest guest = new TransferOrderGuest();
//                            guest.setId(0);
//                            guest.setOrderId(0);
//                            guest.setFromOrderFamilyId(bd.getId());
//                            guest.setName(item.getName());
//                            guest.setType(item.getType());
//                            guest.setCertificateNum(item.getCertificateNum());
//                            guest.setGender(item.getGender());
//                            guest.setMobile(item.getMobile());
//                            guest.setNativePlace(item.getNativePlace());
//                            guest.setAge(item.getAge());
//                            guest.setCareer(item.getCareer());
//                            guest.setIsSingleRoom(item.getIsSingleRoom());
//                            guest.setRemark(item.getRemark());
//                            guests.add(guest);
//                        }
//                    }
//                    //routeList
//                    List<GroupRoute> rlist = routeService.selectByOrderId(go.getId());
//                    if (rlist != null && rlist.size() > 0) {
//                        for (GroupRoute item : rlist) {
//                            TransferOrderRoute gRoute = new TransferOrderRoute();
//                            gRoute.setId(0);
//                            gRoute.setOrderId(0);
//                            gRoute.setFromOrderId(bd.getId());
//                            gRoute.setDayVal(item.getDayNum());
//                            gRoute.setDateVal(item.getGroupDate());
//                            gRoute.setBreakfast(item.getBreakfast());
//                            gRoute.setLunch(item.getLunch());
//                            gRoute.setSupper(item.getSupper());
//                            gRoute.setHotels(item.getHotelName());
//                            gRoute.setRouteDesp(item.getRouteDesp());
//                            routes.add(gRoute);
//                        }
//                    }
//                }
//            }
//        } else {    // 团队订单
//            if (groupOrder != null && groupOrder.size() > 0) {
//                for (GroupOrder go : groupOrder) {
//                    TransferOrderFamily family = new TransferOrderFamily();
//                    List<GroupOrderTransport> groupOrderTransport = groupOrderTransportService
//                            .selectByGroupId(go.getId());
//                    family.setId(0);
//                    family.setOrderId(0);
//                    family.setFromOrderId(0);
//                    family.setFromOrderFamilyId(0);
//                    family.setLeaderName("");
//                    family.setPersonAdult(0);
//                    family.setPersonChild(0);
//                    family.setHotelLevel("");
//                    family.setHotelNums("");
//                    family.setTransportArrival("");// 省外（长线）－接机信息
//                    family.setTransportMiddle("");// 省内（短线）－接送信息
//                    family.setTransportLeave("");// '接送信息：省外（长线）－送机信息',
//                    family.setRemark("");
//                    familys.add(family);
//                    
//                    // 给guestList赋值
//                    List<GroupOrderGuest> gu = guestService.selectByOrderId(go.getId());
//                    if (gu != null && gu.size() > 0) {
//                        for (GroupOrderGuest item : gu) {
//                            TransferOrderGuest guest = new TransferOrderGuest();
//                            guest.setId(0);
//                            guest.setOrderId(0);
//                            guest.setFromOrderFamilyId(bd.getId());
//                            guest.setName(item.getName());
//                            guest.setType(item.getType());
//                            guest.setCertificateNum(item.getCertificateNum());
//                            // guest.setGender(item.getGender());
//                            guest.setMobile(item.getMobile());
//                            guest.setNativePlace(item.getNativePlace());
//                            guest.setAge(item.getAge());
//                            guest.setCareer(item.getCareer());
//                            guest.setIsSingleRoom(item.getIsSingleRoom());
//                            guest.setRemark(item.getRemark());
//                            guests.add(guest);
//                        }
//                    }
//                    //routeList
//                    List<GroupRoute> rlist = routeService.selectByGroupId(tourGroup.getId());
//                    if (rlist != null && rlist.size() > 0) {
//                        for (GroupRoute item : rlist) {
//                            TransferOrderRoute gRoute = new TransferOrderRoute();
//                            gRoute.setId(0);
//                            gRoute.setOrderId(0);
//                            gRoute.setFromOrderId(bd.getId());
//                            gRoute.setDayVal(item.getDayNum());
//                            gRoute.setDateVal(item.getGroupDate());
//                            gRoute.setBreakfast(item.getBreakfast());
//                            gRoute.setLunch(item.getLunch());
//                            gRoute.setSupper(item.getSupper());
//                            gRoute.setHotels(item.getHotelName());
//                            gRoute.setRouteDesp(item.getRouteDesp());
//                            routes.add(gRoute);
//                        }
//                    }
//                }
//            }
//            
//        }
//        // priceList
//        List<BookingDeliveryPrice> bdp = bookingDeliveryPriceService
//                .getPriceListByBookingId(bd.getId());
//        if (bdp != null && bdp.size() > 0) {
//            for (BookingDeliveryPrice item : bdp) {
//                TransferOrderPrice price = new TransferOrderPrice();
//                price.setId(0);
//                price.setOrderId(0);
//                price.setFromOrderId(bd.getId());
//                price.setItem(item.getItemName());
//                price.setRemark(item.getRemark());
//                price.setPrice(item.getUnitPrice());
//                price.setNumTimes(item.getNumTimes());
//                price.setNumPerson(item.getNumPerson());
//                price.setTotal(item.getTotalPrice());
//                prices.add(price);
//            }
//        }
//        
//        String jsonStr = JSON.toJSONString(orderVo);
//        
//        String resultString;
//        try {
//            String fromAppKey = "57354120";
//            String timeStamp = DateUtil.date2Str(new Date(), "yyyy-MM-dd HH:mm:ss");
//            String toAppKey = "56789000";
//            String secretKey = "f966se6dsc898w889yp976s5d7ep6748";
//            //签名
//            Map<String, String> params = new HashMap<String, String>();
//            params.put("appKey", fromAppKey);
//            params.put("timestamp", timeStamp);
//            String getSign = MD5Util.getSign_Taobao(secretKey, params);
//            
//            // 访问接口
//            CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
//            
//            HttpPost httpPost = new HttpPost(OpenPlatformConstannt.openAPI_OrderMap.get("Url")
//                    + OpenPlatformConstannt.openAPI_OrderMap.get("pushMethod"));
//            
//            // 访问参数
//            List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
//            nameValuePairList.add(new BasicNameValuePair("fromAppKey", fromAppKey));
//            nameValuePairList.add(new BasicNameValuePair("timestamp", timeStamp));
//            nameValuePairList.add(new BasicNameValuePair("sign", getSign));
//            nameValuePairList.add(new BasicNameValuePair("toAppKey", toAppKey));
//            nameValuePairList.add(new BasicNameValuePair("jsonStr", jsonStr));
//            
//            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList, "utf-8"));
//            
//            CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);
//            
//            try {
//                HttpEntity httpEntity = closeableHttpResponse.getEntity();
//                resultString = EntityUtils.toString(httpEntity);
//            } finally {
//                closeableHttpResponse.close();
//            }
//            
//        } catch (Exception ex) {
//            //log.error("推送APP错误信息:" + e.getMessage());
//            return errorJson("推送信息失败,请检查客人信息是否正确");
//        }
        
        return successJson(map);
    }
    
    @RequestMapping(value = "agencyConfirm.do", method = RequestMethod.POST)
    @ResponseBody
    public String agencyConfirm(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer id) {
        deliveryService.angencyConfirm(id);
        return successJson();
    }
    
    @RequestMapping(value = "agencyDelele.do", method = RequestMethod.POST)
    @ResponseBody
    public String agencyDelele(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer id) {
        try {
            deliveryService.angencyDelete(id);
            return successJson();
        } catch (ClientException ex) {
            return errorJson(ex.getMessage());
        }
    }
    
    private String getDeliveryBrokerUser(HttpServletRequest request) {
        String userId = WebUtils.getBizConfigValue(request, BizConfigConstant.DELIVERY_BROKER_USER);
        if (StringUtils.isNotEmpty(userId)) {
            return userId;
        }
        return null;
    }
    
    private PlatformEmployeePo getDeliveryBrokerUserInfo(HttpServletRequest request) {
        String userId = WebUtils.getBizConfigValue(request, BizConfigConstant.DELIVERY_BROKER_USER);
        if (StringUtils.isNotEmpty(userId)) {
            return platformEmployeeService.findByEmployeeId(TypeUtils.castToInt(userId));
        }
        return null;
    }
    
    @RequestMapping(value = "deliveryExport.do")
    public String deliveryExport(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer bookingId, Integer type, Integer preview) {
        WordReporter exporter = null;
        try {
            
            SysBizInfo bizInfo = WebUtils.getCurBizInfo(request);
            PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
            BookingDelivery delivery = deliveryService.getBookingInfoById(bookingId);
            //要打印的订单
            //GroupOrder groupOrder = orderService.selectByPrimaryKey(orderId);
            //旅行社信息
            List<Map<String, String>> priceMapList = new ArrayList<Map<String, String>>();
            Map<String, Object> otherMap = new HashMap<String, Object>();
            List<Map<String, String>> orderMapList = null;
            Map<String, Object> remarkMap = new HashMap<String, Object>();
            Map<String, Object> agencyMap = new HashMap<String, Object>();
            List<Map<String, String>> routeMapList = new ArrayList<Map<String, String>>();
            Map<String, Object> staffsMap = new HashMap<String, Object>();
            Map<String, Object> groupMap = new HashMap<String, Object>();
            TourGroup groupInfo = tourGroupService.selectByPrimaryKey(delivery.getGroupId());
            if (groupInfo.getGroupMode() < 1) {
                
                exporter = new WordReporter(request.getSession().getServletContext().getRealPath("/") + "template/booking_delivery_individual.docx");
            }
            if (groupInfo.getGroupMode() > 0) {
                
                exporter = new WordReporter(request.getSession().getServletContext().getRealPath("/") + "template/booking_delivery_team.docx");
            }
            String imgPath = "";
            orderMapList = getDeliveryDetail(preview, request, userInfo, delivery,
                    priceMapList, type, otherMap, orderMapList, remarkMap, agencyMap,
                    routeMapList, staffsMap, groupMap, groupInfo);
            
            
            exporter.init();
            exporter.export(otherMap);
            exporter.export(agencyMap, 0);
            exporter.export(groupMap, 1);
            exporter.export(routeMapList, 2);
            exporter.export(priceMapList, 3, true);
            exporter.export(staffsMap, 4);
            exporter.export(orderMapList, 5);
            exporter.export(remarkMap, 6);
            
            String url = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis() + ".doc";
            exporter.generate(url);
            //下载
            String path = url;
            String fileName = "";
            
            try {
                fileName = new String("地接社确认单.doc".getBytes("UTF-8"),
                        "iso-8859-1");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }// 为了解决中文名称乱码问题
            
            response.setCharacterEncoding("utf-8");
            response.setContentType("application/msword"); // word格式
            try {
                response.setHeader("Content-Disposition", "attachment; filename="
                        + fileName);
                File file = new File(path);
                InputStream inputStream = new FileInputStream(file);
                OutputStream os = response.getOutputStream();
                byte[] b = new byte[10240];
                int length;
                while ((length = inputStream.read(b)) > 0) {
                    os.write(b, 0, length);
                }
                inputStream.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            new File(url).delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 获取地接社打印单中的信息
     *
     * @param request
     * @param userInfo
     * @param delivery
     * @param priceMapList
     * @param otherMap
     * @param orderMapList
     * @param remarkMap
     * @param agencyMap
     * @param routeMapList
     * @param staffsMap
     * @param groupMap
     * @param groupInfo
     * @return
     */
    private List<Map<String, String>> getDeliveryDetail(Integer preview,
                                                        HttpServletRequest request, PlatformEmployeePo userInfo,
                                                        BookingDelivery delivery, List<Map<String, String>> priceMapList, Integer type,
                                                        Map<String, Object> otherMap,
                                                        List<Map<String, String>> orderMapList,
                                                        Map<String, Object> remarkMap, Map<String, Object> agencyMap,
                                                        List<Map<String, String>> routeMapList,
                                                        Map<String, Object> staffsMap, Map<String, Object> groupMap,
                                                        TourGroup groupInfo) {
        String imgPath = "";
        if (type == null || type.equals(1)) {//计调-》地接社
            agencyMap.put("suppliername", delivery.getSupplierName());
            agencyMap.put("contact", delivery.getContact());
            agencyMap.put("contacttel", delivery.getContactMobile());
            agencyMap.put("contactfax", delivery.getContactFax());
            agencyMap.put("company", WebUtils.getCurOrgInfo(request).getName());
            agencyMap.put("username", userInfo.getName());
            agencyMap.put("usertel", userInfo.getMobile());
            agencyMap.put("userfax", userInfo.getFax());
            
            imgPath = bizSettingCommon.getMyBizLogo(request);
        } else if (type.equals(2)) {//计调-》集团
            PlatformEmployeePo broker = getDeliveryBrokerUserInfo(request);
            if (broker != null) {
                agencyMap.put("suppliername", "怡美国际旅游集团");
                agencyMap.put("contact", broker.getName());
                agencyMap.put("contacttel", broker.getMobile());
                agencyMap.put("contactfax", broker.getFax());
            } else {
                agencyMap.put("suppliername", "");
                agencyMap.put("contact", "");
                agencyMap.put("contacttel", "");
                agencyMap.put("contactfax", "");
            }
            agencyMap.put("company", WebUtils.getCurOrgInfo(request).getName());
            agencyMap.put("username", userInfo.getName());
            agencyMap.put("usertel", userInfo.getMobile());
            agencyMap.put("userfax", userInfo.getFax());
            
            imgPath = bizSettingCommon.getMyBizLogo(request);
        } else if (type.equals(3)) {//集团-》地接社
            PlatformEmployeePo broker = getDeliveryBrokerUserInfo(request);
            agencyMap.put("suppliername", delivery.getSupplierName());
            agencyMap.put("contact", delivery.getContact());
            agencyMap.put("contacttel", delivery.getContactMobile());
            agencyMap.put("contactfax", delivery.getContactFax());
            if (broker != null) {
                agencyMap.put("company", "怡美国际旅游集团");
                agencyMap.put("username", broker.getName());
                agencyMap.put("usertel", broker.getMobile());
                agencyMap.put("userfax", broker.getFax());
                
                imgPath = bizSettingCommon.getOrgLogo(WebUtils.getCurBizId(request), broker.getOrgId());
            } else {
                agencyMap.put("company", "");
                agencyMap.put("username", "");
                agencyMap.put("usertel", "");
                agencyMap.put("userfax", "");
                
                imgPath = null;
            }
        }
        
        //logo和打印时间
        if (imgPath != null) {
            Map<String, String> picMap = new HashMap<String, String>();
            picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
            picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
            picMap.put("type", "jpg");
            picMap.put("path", imgPath);
            otherMap.put("logo", picMap);
        } else {
            otherMap.put("logo", "");
        }
        //团信息
        List<GroupRoute> routeList = routeService.selectByGroupIdAndBookingId(delivery.getGroupId(), delivery.getId());
//	groupMap.put("company", bizInfo.getName());
        
        groupMap.put("totaladult", delivery.getPersonAdult().toString());
        groupMap.put("totalchild", delivery.getPersonChild().toString());
        groupMap.put("total_guide", delivery.getPersonGuide().toString());
        groupMap.put("groupcode", groupInfo.getGroupCode());
        groupMap.put("productBrand", groupInfo.getProductBrandName().toString());
        groupMap.put("productName", groupInfo.getProductName().toString());        //行程
        if (routeList != null && routeList.size() > 0) {
            for (GroupRoute route : routeList) {
                Map<String, String> routeMap = new HashMap<String, String>();
                Date date = DateUtils.addDays(groupInfo.getDateStart(), route.getDayNum() - 1);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                routeMap.put("day", sdf.format(date));
                routeMap.put("routedesp", route.getRouteDesp());
                routeMap.put("isbreakfast", route.getBreakfast());
                routeMap.put("islunch", route.getLunch());
                routeMap.put("issupper", route.getSupper());
                routeMap.put("hotelname", route.getHotelName());
                routeMapList.add(routeMap);
            }
        }
        //价格
        List<BookingDeliveryPrice> priceList = delivery.getPriceList();
        if (priceList != null && priceList.size() > 0) {
            int index = 1;
            double total = 0.0;
            for (BookingDeliveryPrice price : priceList) {
                Map<String, String> priceMap = new HashMap<String, String>();
                priceMap.put("seq", index + "");
                priceMap.put("itemname", price.getItemName());
                priceMap.put("remark", price.getRemark());
                priceMap.put("unitprice", NumberUtil.formatDouble(price.getUnitPrice().doubleValue()));
                priceMap.put("numtimes", NumberUtil.formatDouble(price.getNumTimes()));
                priceMap.put("numperson", NumberUtil.formatDouble(price.getNumPerson()));
                priceMap.put("totalprice", NumberUtil.formatDouble(price.getTotalPrice().doubleValue()));
                total += delivery.getTotal().doubleValue();
                priceMapList.add(priceMap);
                index++;
            }
            Map<String, String> priceMap = new HashMap<String, String>();
            priceMap.put("total", total + "");
            priceMapList.add(priceMap);
        } else {
            Map<String, String> priceMap = new HashMap<String, String>();
            priceMap.put("total", 0 + "");
            priceMapList.add(priceMap);
        }
        //团工作人员信息
        //获取司机信息
        List<BookingSupplierDetail> driversList = detailService.getDriversByGroupIdAndType(groupInfo.getId(), Constants.FLEET);
        //获取导游信息
        List<BookingGuide> bGuides = guideService.selectByGroupId2(groupInfo.getId());
        //获取接站信息
        List<GroupOrder> orderList = null;
        if (groupInfo.getGroupMode() > 0) {//团队
            orderList = orderService.selectOrderByGroupId(groupInfo.getId());
        } else {//散客
            List<BookingDeliveryOrder> deliveryOrderList = delivery.getOrderList();
            orderList = new ArrayList<GroupOrder>();
            if (deliveryOrderList != null && deliveryOrderList.size() > 0) {
                for (BookingDeliveryOrder deliveryOrder : deliveryOrderList) {
                    orderList.add(orderService.selectByPrimaryKey(deliveryOrder.getOrderId()));
                }
            }
        }
        
        //获取全陪领队信息
        if (orderList != null && orderList.size() > 0) {
            List<GroupOrderGuest> guestList = guestService.selectByOrderId(orderList.get(0).getId());
            if (guestList != null && guestList.size() > 0) {
                /*for (GroupOrderGuest guest : guestList) {
                    if(guest.getIsLeader()==1){
						staffsMap.put("leadername", guest.getName()==null?"":guest.getName());
						staffsMap.put("leadertel", guest.getMobile()==null?"":guest.getMobile());
						break;
					}
				}
				for (GroupOrderGuest guest : guestList) {
					if (guest.getType()==3) {
						staffsMap.put("accompanyname", guest.getName()==null?"":guest.getName());
						staffsMap.put("accompanytel", guest.getMobile()==null?"":guest.getMobile());
						break;
					} 
				}*/
                staffsMap.put("leaderInfo", getLeaderInfo(guestList));
                staffsMap.put("accompanyInfo", getAccompanyInfo(guestList));
                
            }
        } else {
            staffsMap.put("leaderInfo", "");
            //staffsMap.put("leadertel", "");
            staffsMap.put("accompanyInfo", "");
            //staffsMap.put("accompanytel", "");
        }
        
        if (driversList != null && driversList.size() > 0) {
            //staffsMap.put("drivername", driversList.get(0).getDriverName());
            staffsMap.put("driverInfo", getDriverInfo(driversList));
        } else {
            staffsMap.put("driverInfo", "");
            
        }
        if (bGuides != null && bGuides.size() > 0) {
            //staffsMap.put("guidename", bGuide.getGuideName());
            staffsMap.put("guideInfo", getGuideInfo(bGuides));
        } else {
            staffsMap.put("guideInfo", "");
            
        }
        if (orderList != null && orderList.size() > 0) {
            staffsMap.put("receivemode", orderList.get(0).getReceiveMode());
        } else {
            
            staffsMap.put("receivemode", "");
        }
        /////////////////////添加地接社确认单打印内容增加接送明细，客人名单，酒店用房需求///////////////////////////
        List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
        GroupOrderPrintPo gopp = null;
        // 房量总计
        String total = "";
        if (groupInfo != null && groupInfo.getGroupMode() < 1) {
            for (GroupOrder order : orderList) {
                // 拿到单条订单信息
                gopp = new GroupOrderPrintPo();
                gopp.setPlace((order.getProvinceName() == null ? "" : order
                        .getProvinceName())
                        + (order.getCityName() == null ? "" : order.getCityName()));
                gopp.setRemark(order.getRemarkInternal());
                // 根据散客订单统计客人信息
                List<GroupOrderGuest> guests = guestService
                        .selectByOrderId(order.getId());
                //客人-接送方式
                gopp.setGuesStatic(order.getReceiveMode());
                if (guests.size() > 0) {
                    gopp.setGuestInfo(getGuestInfoNoPhone(guests));
                }
                
                // 根据散客订单统计人数
                Integer numAdult = guestService
                        .selectNumAdultByOrderID(order.getId());
                Integer numChild = guestService
                        .selectNumChildByOrderID(order.getId());
                gopp.setPersonNum(numAdult + "+" + numChild);
                
                // 根据散客订单统计酒店信息
                List<GroupRequirement> grogShopList = groupRequirementService
                        .selectByOrderAndType(order.getId(), 3);
                if (grogShopList.size() > 0) {
                    if (grogShopList.get(0).getHotelLevel() != null) {
                        gopp.setHotelLevel(dicService.getById(
                                grogShopList.get(0).getHotelLevel()).getValue()
                                + "\n");
                    }
                    gopp.setHotelNum(getHotelNum(grogShopList));
                }
                total = getHotelTotalNum(grogShopList);
                // 省外交通
                // 根据散客订单统计接机信息
                List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
                        .selectByOrderId(order.getId());
                gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
                // 根据散客订单统计送机信息
                gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
                
                // 省内交通
                gopp.setTrans(getSourceType(groupOrderTransports));
                gopps.add(gopp);
            }
        
		/*
         * 第二个表格
		 */
            //如果是散客团
            
            orderMapList = new ArrayList<Map<String, String>>();
            int i = 1;
            for (GroupOrderPrintPo po : gopps) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("num", "" + (i++));
                //map.put("supplierName", po.getSupplierName());
                //map.put("salePerson", po.getSaleOperatorName());
                map.put("guestStatic", po.getGuesStatic());
                map.put("personNum", po.getPersonNum());
                //map.put("place", po.getPlace());
                map.put("hotelLevel", po.getHotelLevel());
                map.put("hotelNum", po.getHotelNum());
                map.put("up", po.getAirPickup());
                map.put("off", po.getAirOff());
                //map.put("airOff", po.getAirOff());
                map.put("trans", po.getTrans());
                map.put("guestInfo", po.getGuestInfo());
                map.put("remark", po.getRemark());
                orderMapList.add(map);
            }
        }
        //如果是定制团
        if (groupInfo != null && groupInfo.getGroupMode() > 0) {
            orderMapList = new ArrayList<Map<String, String>>();
            Map parameters = new HashMap();
            parameters.put("groupId", groupInfo.getId());
            parameters.put("supplierId", null);
            parameters.put("bizId", WebUtils.getCurBizId(request));
            List<GroupOrderGuest> orderGuests = guestService.getGroupOrderGuests(parameters);
            int index = 1;
            for (GroupOrderGuest guest : orderGuests) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("num", (index++) + "");
                map.put("name", guest.getName() == null ? "" : guest.getName());
                map.put("sex", guest.getGender() == 0 ? "男" : "女");
                map.put("mobile", guest.getMobile() == null ? "" : guest.getMobile());
                map.put("IDCard", guest.getCertificateNum() == null ? "" : guest.getCertificateNum());
                map.put("address", guest.getNativePlace() == null ? "" : guest.getNativePlace());
                map.put("age", guest.getAge() == null ? "0" : (guest.getAge() + ""));
                map.put("remark", guest.getRemark() == null ? "" : guest.getRemark());
                orderMapList.add(map);
                
            }
        }
        //打印页面
        if (preview == null) {
            remarkMap
                    .put("remark", delivery.getRemark());
            //服务标准
            remarkMap.put("serviceStandard", groupInfo.getServiceStandard());
            //团备注
            remarkMap.put("groupRemark",
                    groupInfo.getRemark());
        } else {
            //备注
            remarkMap
                    .put("remark", delivery.getRemark().replace("\n", "<br/>"));
            //服务标准
            remarkMap.put("serviceStandard", groupInfo.getServiceStandard()
                    .replace("\n", "<br/>"));
            //团备注
            remarkMap.put("groupRemark",
                    groupInfo.getRemark().replace("\n", "<br/>"));
            
        }
        //其他logo、打印时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
        otherMap.put("print_time", df.format(new Date()));
        return orderMapList;
    }
    
    private String getGuideInfo(List<BookingGuide> bGuides) {
        StringBuilder sb = new StringBuilder();
        for (BookingGuide guide : bGuides) {
            sb.append(guide.getGuideName() + "-" + guide.getGuideMobile() + "\n");
        }
        return sb.toString();
    }
    
    private String getDriverInfo(List<BookingSupplierDetail> driversList) {
        
        StringBuilder sb = new StringBuilder();
        for (BookingSupplierDetail driver : driversList) {
            sb.append(driver.getDriverName() + "-" + driver.getDriverTel() + "\n");
        }
        return sb.toString();
    }
    
    private String getAccompanyInfo(List<GroupOrderGuest> guestList) {
        StringBuilder sb = new StringBuilder();
        for (GroupOrderGuest guest : guestList) {
            if (guest.getType() == 3) {
                
                sb.append(guest.getName() + "-" + guest.getMobile() + "\n");
            }
        }
        return sb.length() <= 0 ? "" : sb.toString();
    }
    
    private String getLeaderInfo(List<GroupOrderGuest> guestList) {
        StringBuilder sb = new StringBuilder();
        for (GroupOrderGuest guest : guestList) {
            if (guest.getIsLeader() == 1) {
                
                sb.append(guest.getName() + "-" + guest.getMobile() + "\n");
            }
        }
        return sb.length() <= 0 ? "" : sb.toString();
    }
    
    /**
     * 返回客人信息(包含电话号码)
     *
     * @param guests
     * @return
     */
    public String getGuestInfoNoPhone(List<GroupOrderGuest> guests) {
        StringBuilder sb = new StringBuilder();
        for (GroupOrderGuest guest : guests) {
            sb.append(guest.getName());
            if (StringUtils.isNotEmpty(guest.getMobile())) {
                sb.append("（");
                sb.append(guest.getMobile());
                sb.append("）");
            }
            sb.append(" ");
            sb.append(guest.getCertificateNum());
            sb.append("\n");
        }
        return sb.toString();
    }
    
    /**
     * 统计酒店总房间数
     *
     * @param grogShopList
     * @return
     */
    public String getHotelTotalNum(List<GroupRequirement> grogShopList) {
        StringBuilder sb = new StringBuilder();
        Integer sr = 0;
        Integer dr = 0;
        Integer tr = 0;
        Integer eb = 0;
        Integer pf = 0;
        for (GroupRequirement gr : grogShopList) {
            if (gr.getCountSingleRoom() != null && gr.getCountSingleRoom() != 0) {
                sr += gr.getCountSingleRoom();
            }
            if (gr.getCountDoubleRoom() != null && gr.getCountDoubleRoom() != 0) {
                dr += gr.getCountDoubleRoom();
            }
            if (gr.getCountTripleRoom() != null && gr.getCountTripleRoom() != 0) {
                tr += gr.getCountTripleRoom();
            }
            if (gr.getExtraBed() != null && gr.getExtraBed() != 0) {
                eb += gr.getExtraBed();
            }
            if (gr.getPeiFang() != null && gr.getPeiFang() != 0) {
                pf += gr.getPeiFang();
            }
        }
        if (sr != 0) {
            sb.append(sr + "单 ");
        }
        if (dr != 0) {
            sb.append(dr + "标 ");
        }
        if (tr != 0) {
            sb.append(tr + "三人间 ");
        }
        if (eb != 0) {
            sb.append(eb + "加床 ");
        }
        if (pf != 0) {
            sb.append(pf + "陪房 ");
        }
        return sb.toString();
    }
    
    /**
     * 返回酒店信息（不包含星级）
     *
     * @param grogShopList
     * @return
     */
    public String getHotelNum(List<GroupRequirement> grogShopList) {
        StringBuilder sb = new StringBuilder();
        if (grogShopList.size() > 0) {
            String sr = "";
            String dr = "";
            String tr = "";
            String eb = "";
            String pf = "";
            GroupRequirement gr = grogShopList.get(0);
            if (gr.getCountSingleRoom() != null && gr.getCountSingleRoom() != 0) {
                sr = gr.getCountSingleRoom() + "单间" + " ";
            }
            if (gr.getCountDoubleRoom() != null && gr.getCountDoubleRoom() != 0) {
                dr = gr.getCountDoubleRoom() + "标间" + " ";
            }
            if (gr.getCountTripleRoom() != null && gr.getCountTripleRoom() != 0) {
                tr = gr.getCountTripleRoom() + "三人间" + "";
            }
            if (gr.getExtraBed() != null && gr.getExtraBed() != 0) {
                eb = gr.getExtraBed() + "加床" + "";
            }
            if (gr.getPeiFang() != null && gr.getPeiFang() != 0) {
                pf = gr.getPeiFang() + "陪房";
            }
            sb.append(sr + dr + tr + eb + pf);
        }
        return sb.toString();
    }
    
    /**
     * 接送信息
     *
     * @param groupOrderTransports
     * @param flag                 0表示接信息 1表示送信息
     * @return
     */
    public String getAirInfo(List<GroupOrderTransport> groupOrderTransports,
                             Integer flag) {
        StringBuilder sb = new StringBuilder();
        if (flag == 0) {
            for (GroupOrderTransport transport : groupOrderTransports) {
                if (transport.getType() == 0 && transport.getSourceType() == 1) {
                    sb.append(
                            (transport.getDepartureCity() == null ? "" : transport.getDepartureCity()) + "/"
                                    + (transport.getArrivalCity() == null ? "" : transport.getArrivalCity()) + " "
                                    + (transport.getClassNo() == null ? "" : transport.getClassNo()) + " "
                                    + " 发出时间：" + (com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(), "MM-dd") == null ? "" : com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(), "MM-dd"))
                                    + " "
                                    + (transport.getDepartureTime() == null ? "" : transport.getDepartureTime()) + "\n");
                }
            }
        }
        if (flag == 1) {
            for (GroupOrderTransport transport : groupOrderTransports) {
                if (transport.getType() == 1 && transport.getSourceType() == 1) {
                    sb.append(
                            (transport.getDepartureCity() == null ? "" : transport.getDepartureCity()) + "/"
                                    + (transport.getArrivalCity() == null ? "" : transport.getArrivalCity()) + " "
                                    + (transport.getClassNo() == null ? "" : transport.getClassNo()) + " "
                                    + " 发出时间：" + (com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(), "MM-dd") == null ? "" : com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(), "MM-dd"))
                                    + " "
                                    + (transport.getDepartureTime() == null ? "" : transport.getDepartureTime()) + "\n");
                }
            }
        }
        return sb.toString();
    }
    
    /**
     * 省内交通
     *
     * @param groupOrderTransports
     * @param flag                 0表示接信息 1表示送信息
     * @return
     */
    public String getSourceType(List<GroupOrderTransport> groupOrderTransports) {
        StringBuilder sb = new StringBuilder();
        for (GroupOrderTransport transport : groupOrderTransports) {
            if (transport.getSourceType() == 0) {
                Date departureDate = transport.getDepartureDate();
                String departureTime = transport.getDepartureTime();
                String md = "";
                String hm = "";
                if (departureTime != null) {
                    md = DateUtil.date2Str(departureDate, "MM-dd");
                    hm = departureTime;
                }
                sb.append(md + " " + transport.getDepartureCity() + "/"
                        + transport.getArrivalCity() + " "
                        + transport.getClassNo() + " " + hm + "\n");
            }
        }
        return sb.toString();
    }
    
    @RequestMapping("deliveryDetailPreview.htm")
    public String deliveryDetailPreview(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer bookingId, Integer type, Integer preview) {
        SysBizInfo bizInfo = WebUtils.getCurBizInfo(request);
        PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
        BookingDelivery delivery = deliveryService.getBookingInfoById(bookingId);
        //要打印的订单
        //GroupOrder groupOrder = orderService.selectByPrimaryKey(orderId);
        //旅行社信息
        List<Map<String, String>> priceMapList = new ArrayList<Map<String, String>>();
        Map<String, Object> otherMap = new HashMap<String, Object>();
        List<Map<String, String>> orderMapList = null;
        Map<String, Object> remarkMap = new HashMap<String, Object>();
        Map<String, Object> agencyMap = new HashMap<String, Object>();
        List<Map<String, String>> routeMapList = new ArrayList<Map<String, String>>();
        Map<String, Object> staffsMap = new HashMap<String, Object>();
        Map<String, Object> groupMap = new HashMap<String, Object>();
        TourGroup groupInfo = tourGroupService.selectByPrimaryKey(delivery.getGroupId());
        orderMapList = getDeliveryDetail(preview, request, userInfo, delivery, priceMapList, type, otherMap, orderMapList, remarkMap, agencyMap, routeMapList, staffsMap, groupMap, groupInfo);
        String imgPath = bizSettingCommon.getMyBizLogo(request);
        model.addAttribute("imgPath", imgPath);
        model.addAttribute("priceMapList", priceMapList);
        model.addAttribute("otherMap", otherMap);
        model.addAttribute("orderMapList", orderMapList);
        model.addAttribute("remarkMap", remarkMap);
        model.addAttribute("agencyMap", agencyMap);
        model.addAttribute("routeMapList", routeMapList);
        model.addAttribute("staffsMap", staffsMap);
        model.addAttribute("groupMap", groupMap);
        model.addAttribute("bookingId", bookingId);
        if (groupInfo.getGroupMode() < 1) {
            
            return "operation/delivery/deliveryDetailPreview-individual";
            
        }
        if (groupInfo.getGroupMode() > 0) {
            
            return "operation/delivery/deliveryDetailPreview-team";
            
        }
        return null;
    }
}
