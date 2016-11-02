package com.yihg.erp.controller.aiYou;

import com.alibaba.dubbo.common.json.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.common.AiYouOpBillDetailBean;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.Tourist;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.MD5Util;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.product.api.*;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductRoute;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierInfo;
import com.yimayhd.erpcenter.biz.sales.client.service.sales.GroupOrderBiz;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.*;
import com.yimayhd.erpcenter.dal.sales.client.sales.service.FitOrderDal;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.FitOrderVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.sales.result.ListResultSupport;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value = "/aiyou")
public class AiYouController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AiYouController.class);
    @Autowired
    private BizSettingCommon settingCommon;

    @Autowired
    private GroupOrderBiz groupOrderBiz;
    @Autowired
    private GroupOrderFacade groupOrderFacade;
    @Autowired
    private SysConfig config;
    @Autowired
    private FitOrderDal fitOrderDal;

    /**
     * 获取爱游订单
     *
     * @param request
     * @param code      商家编码
     * @param port      平台来源
     * @param startDate 发团开始日期
     * @param endDate   发团结束日期
     * @param groupNum  团号
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "toAiYouOrderList.htm")
    public String toAiYouOrderList(HttpServletRequest request,
                                   String code,
                                   String port,
                                   String startDate,
                                   String endDate,
                                   String groupNum,
                                   Model model) throws Exception {
        /* old 访问爱游数据 修改为新访问 ZM */
        // if (code == null || code.equals("")) {
        // code = "KMLSLXS";
        // }
        // if (port == null || port.equals("")) {
        // port = "AY";
        // }
        // if (startDate == null || startDate.equals("")) {
        // startDate = DateUtils.getMonthFirstDay();
        // }
        // if (endDate == null || endDate.equals("")) {
        // endDate = new SimpleDateFormat("YYYY-MM-dd").format(new Date());
        // }
        //
        // // 爱游
        // HttpClient httpClient = new DefaultHttpClient();
        //
        // List<AiYouBean> aiyouOrderList = new ArrayList<AiYouBean>();
        //
        // String getOrdersUrl =
        // "http://{{ip}}/aiyou/api/erp.do?m=getGroupOrders&code={{group_code}}&group_date_start={{group_date_start}}&group_date_end={{group_date_end}}"
        // .replace("{{ip}}", Constants.aiYouUrlMap.get(port))
        // .replace("{{group_code}}", code)
        // .replace("{{group_date_start}}", startDate)
        // .replace("{{group_date_end}}", endDate);
        //
        // Map<String, String> params = new HashMap<String, String>();
        // params.put("m", "getGroupOrders");
        // params.put("code", code);
        // params.put("group_date_start", startDate);
        // params.put("group_date_end", endDate);
        // String sign = getSign(code, MD5(code + "erp"), params);
        // getOrdersUrl += "&sign=" + sign;
        // HttpGet getOrders = new HttpGet(getOrdersUrl);
        // HttpResponse orderstr = httpClient.execute(getOrders);
        // String r = EntityUtils.toString(orderstr.getEntity());
        //
        // List<AiYouBean> aiYouBeans = JSONArray.parseArray(r,
        // AiYouBean.class);
        // if (aiYouBeans != null && aiYouBeans.size() > 0) {
        // List<GroupOrder> orders = groupOrderService.selectAiYouOrders(
        // WebUtils.getCurBizId(request), startDate, endDate);
        // for (AiYouBean aiYouBean : aiYouBeans) {
        // aiYouBean.setSupplierCode(port);
        // String yyyy = aiYouBean.getGroup_num().substring(0, 4);
        // String MM = aiYouBean.getGroup_num().substring(4, 6);
        // String dd = aiYouBean.getGroup_num().substring(6, 8);
        // aiYouBean.setDate(yyyy + "-" + MM + "-" + dd);
        // if (orders != null && orders.size() > 0) {
        // for (GroupOrder groupOrder : orders) {
        // if (aiYouBean.getGroup_id().equals(
        // groupOrder.getAiyouGroupId())) {
        // aiYouBean.setIsImport(1);
        // break;
        // }
        // }
        // }
        // }
        // aiyouOrderList.addAll(aiYouBeans);
        // }
        //
        // getOrders.abort();
        /* old 访问爱游数据 END */

        if (code == null || "".equals(code)) { // 默认商家编码
            code = "KMLSLXS";
        }

        if (port == null || "".equals(port)) { // 默认平台来源
            port = "AY";
        }

        if (startDate == null || "".equals(startDate)) {
            startDate = DateUtils.getMonthFirstDay();
        }

        if (endDate == null || "".equals(endDate)) {
            endDate = DateUtils.getMonthFirstDay();
        }

        Integer bizId = WebUtils.getCurBizId(request);

        List<AiYouBean> aiyouOrderList = Collections.emptyList();
        ListResultSupport<AiYouBean> resultSupport = groupOrderFacade.getAiYourOrders(code, port, startDate, endDate, groupNum, bizId);
        if(resultSupport!=null && resultSupport.isSuccess()){
            aiyouOrderList = resultSupport.getValues();
        }

        model.addAttribute("code", code);
        model.addAttribute("port", port);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("groupNum", groupNum);
        model.addAttribute("aiyouOrderList", aiyouOrderList);

        model.addAttribute("curUser", WebUtils.getCurUser(request));

        return "aiyou/orderList";
    }

    @RequestMapping(value = "/saveAiYouData")
    @ResponseBody
    public String saveAiYouData(HttpServletRequest request,
                                String code,
                                String port,
                                @RequestParam("bIds[]") String[] bIds,
                                Integer saleOperatorId,
                                String saleOperatorName,
                                Integer operatorId,
                                String operatorName,
                                Integer supplierId,
                                String supplierName,
                                Integer productBrandId,
                                String productBrandName,
                                Integer productId,
                                String productName) throws Exception {

        // 访问爱游系统 (yihg-aiyou-api[数据查询系统])
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        // 访问地址
        HttpPost httpPost = new HttpPost(Constants.AIYOU_API_URL + "/opBill/orderDetialList.do");
        // 访问参数
        List<NameValuePair> nameValuePairList = new
                ArrayList<NameValuePair>();
        nameValuePairList.add(new BasicNameValuePair("dbType", port));
        nameValuePairList.add(new BasicNameValuePair("code", code));
        for (String bId : bIds) {
            nameValuePairList.add(new BasicNameValuePair("bids", bId));
        }

        httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList));

        CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);

        String orderString = "";
        try {
            HttpEntity httpEntity = closeableHttpResponse.getEntity();

            orderString = EntityUtils.toString(httpEntity);
        } finally {
            closeableHttpResponse.close();
        }

        // 商家ID
        Integer bizId = WebUtils.getCurBizId(request);
        Integer userId = WebUtils.getCurUserId(request);
        String userName = WebUtils.getCurUser(request).getName();
        long currentTime = System.currentTimeMillis();

        List<AiYouOpBillDetailBean> aiYouOpBillDetailBeanList = JSONArray.parseArray(orderString, AiYouOpBillDetailBean.class);

        ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(productId);
        ProductInfo productInfo = productInfoService.findProductInfoById(productId);
        List<ProductRoute> productRouteList = productRouteService.findProductRouteByProductId(productId);

        List<GroupRoute> groupRouteList = new ArrayList<GroupRoute>();
        for (ProductRoute productRoute : productRouteList) {
            GroupRoute groupRoute = new GroupRoute();
            groupRoute.setDayNum(productRoute.getDayNum());
            groupRoute.setBreakfast(productRoute.getBreakfast());
            groupRoute.setLunch(productRoute.getLunch());
            groupRoute.setSupper(productRoute.getSupper());
            groupRoute.setHotelId(productRoute.getHotelId());
            groupRoute.setHotelName(productRoute.getHotelName());
            groupRoute.setRouteDesp(productRoute.getRouteDesp());
            groupRoute.setRouteTip(productRoute.getRouteTip());
            groupRoute.setCreateTime(currentTime);

            groupRouteList.add(groupRoute);
        }

        List<GroupOrder> groupOrderList = new ArrayList<GroupOrder>();
        for (AiYouOpBillDetailBean aiYouOpBillDetailBean : aiYouOpBillDetailBeanList) {
            GroupOrder groupOrder = new GroupOrder();

            groupOrder.setBizId(bizId); // biz_id
            groupOrder.setOrderType(-1); // order_type 订单类型 为-1一地散
            groupOrder.setSupplierName(supplierName); // supplier_name
            groupOrder.setSupplierId(supplierId); // supplier_id
            /// order_no_sort
            /// order_no
            groupOrder.setSupplierCode(aiYouOpBillDetailBean.getGroupNum()); // supplier_code
            // contact_name
            // contact_tel
            // contact_mobile
            // contact_fax
            groupOrder.setOperatorId(operatorId); // operator_id
            groupOrder.setOperatorName(operatorName); // operator_name
            groupOrder.setSaleOperatorId(saleOperatorId); // sale_operator_id
            groupOrder.setSaleOperatorName(saleOperatorName); // sale_operator_name
            groupOrder.setNumAdult(aiYouOpBillDetailBean.getAdultNum()); // num_adult
            groupOrder.setNumChild(aiYouOpBillDetailBean.getChildrenNum()); // num_child
            // num_guide
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date(Long.parseLong(aiYouOpBillDetailBean.getStartDate()));
            groupOrder.setDepartureDate(sdf.format(date)); // departure_date

            groupOrder.setProductId(productId); // product_id
            groupOrder.setProductBrandId(productBrandId); // product_brand_id
            groupOrder.setProductBrandName(productBrandName); // product_brand_name
            groupOrder.setProductName(productName); // product_name
            groupOrder.setProductShortName(productInfo.getNameCity()); // product_short_name
            groupOrder.setReceiveMode(aiYouOpBillDetailBean.getGroupNum().substring(8)); // receive_mode
            groupOrder.setServiceStandard(productRemark.getServeLevel()); // service_standard
            groupOrder.setRemark(productRemark.getRemarkInfo()); // remark
            String memo = "";
            if (aiYouOpBillDetailBean.getMemo() != null) {
                memo += aiYouOpBillDetailBean.getMemo() + "\n";
            }
            memo += "爱游产品名：" + aiYouOpBillDetailBean.getProductName() + "\n";
            if (aiYouOpBillDetailBean.getShuttleInfo() != null) {
                List<HashMap> hashMapList = JSONArray.parseArray(aiYouOpBillDetailBean.getShuttleInfo(), HashMap.class);
                List list = new ArrayList();
                for (HashMap hashMap : hashMapList) {
                    list.add(hashMap.get("info"));
                }
                memo += "机票：" + com.alibaba.fastjson.JSON.toJSONString(list) + "\n";
            }
            if (aiYouOpBillDetailBean.getAcomInfo() != null) {
                memo += "用房：" + aiYouOpBillDetailBean.getAcomInfo() + "\n";
            }
            groupOrder.setRemarkInternal(memo); // remark_internal
            groupOrder.setCreatorId(userId); // creator_id
            groupOrder.setCreatorName(userName); // creator_name
            groupOrder.setCreateTime(currentTime); // create_time
            groupOrder.setState(1); // state
            // state_finance
            // total
            // total_cash
            // audit_user
            // audit_user_id
            // audit_time
            // price_id
            // operate_log
            // state_seal
            // seal_user
            // seal_user_id
            // seal_time
            // source_type_id
            // source_type_name
            // province_id
            // province_name
            // city_id
            // city_name
            // order_lock_state
            // type
            // contract_no
            // guest_source_id
            // guest_source_name
            groupOrder.setAiyouGroupId(aiYouOpBillDetailBean.getBid()); // aiyou_group_id
            // b2b_export_state

            // 保存订单信息表 group_order
            groupOrderList.add(groupOrder);

            List<GroupOrderGuest> groupOrderGuestList = new ArrayList<GroupOrderGuest>();
            for (int i = 0; i < aiYouOpBillDetailBean.getMembers().size(); i++) {
                GroupOrderGuest groupOrderGuest = new GroupOrderGuest();
                groupOrderGuest.setName(aiYouOpBillDetailBean.getMembers().get(i).getMname());
                groupOrderGuest.setCertificateNum(aiYouOpBillDetailBean.getMembers().get(i).getIdno());
                groupOrderGuest.setMobile(aiYouOpBillDetailBean.getMembers().get(i).getMobile());
                groupOrderGuest.setCertificateTypeId(dicService
                        .getDicInfoByTypeCodeAndDicCode(BasicConstants.GYXX_ZJLX, BasicConstants.GYXX_ZJLX_SFZ)
                        .getId());
                if ("adult".equals(aiYouOpBillDetailBean.getMembers().get(i).getMtype())) {
                    groupOrderGuest.setType(1);
                } else if ("child".equals(aiYouOpBillDetailBean.getMembers().get(i).getMtype())) {
                    groupOrderGuest.setType(2);
                }

                groupOrderGuest.setNativePlace(aiYouOpBillDetailBean.getMembers().get(i).getNativeplace());
                groupOrderGuest.setAge(aiYouOpBillDetailBean.getMembers().get(i).getAge());
                groupOrderGuest.setRemark("");
                
                groupOrderGuestList.add(groupOrderGuest);
            }
            // 保存订单客人信息表 group_order_guest
            groupOrder.setGroupOrderGuestList(groupOrderGuestList);

            List<GroupOrderPrice> groupOrderPriceList = new ArrayList<GroupOrderPrice>();
            GroupOrderPrice groupOrderPrice;
            if (aiYouOpBillDetailBean.getAdultNum() > 0) {
                groupOrderPrice = new GroupOrderPrice();
                groupOrderPrice.setMode(0);
                groupOrderPrice.setNumTimes(1.0);

                groupOrderPrice.setItemId(dicService
                        .getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.CR).getId());
                groupOrderPrice.setItemName(dicService
                        .getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.CR).getValue());

                groupOrderPrice.setUnitPrice(aiYouOpBillDetailBean.getPrice());
                groupOrderPrice.setNumPerson(Double.parseDouble(aiYouOpBillDetailBean.getAdultNum().toString()));
                groupOrderPrice.setTotalPrice(groupOrderPrice.getUnitPrice() * groupOrderPrice.getNumTimes() * groupOrderPrice.getNumPerson());

                groupOrderPrice.setCreatorId(userId);
                groupOrderPrice.setCreatorName(userName);
                groupOrderPrice.setCreateTime(currentTime);

                groupOrderPriceList.add(groupOrderPrice);

                groupOrder.setTotal(new BigDecimal(groupOrderPrice.getTotalPrice()));

                if (aiYouOpBillDetailBean.getChildrenNum() != null && aiYouOpBillDetailBean.getChildrenNum() > 0) {
                    groupOrderPrice = new GroupOrderPrice();
                    groupOrderPrice.setMode(0);
                    groupOrderPrice.setNumTimes(1.0);

                    groupOrderPrice.setItemId(dicService
                            .getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.ERT).getId());
                    groupOrderPrice.setItemName(dicService
                            .getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.ERT).getValue());

                    groupOrderPrice.setUnitPrice(aiYouOpBillDetailBean.getChildPrice());
                    groupOrderPrice.setNumPerson(Double.parseDouble(aiYouOpBillDetailBean.getChildrenNum().toString()));
                    groupOrderPrice.setTotalPrice(groupOrderPrice.getUnitPrice() * groupOrderPrice.getNumTimes() * groupOrderPrice.getNumPerson());

                    groupOrderPrice.setCreatorId(userId);
                    groupOrderPrice.setCreatorName(userName);
                    groupOrderPrice.setCreateTime(currentTime);

                    groupOrderPriceList.add(groupOrderPrice);

                    groupOrder.setTotal(new BigDecimal(groupOrderPrice.getTotalPrice()).add(groupOrder.getTotal()));
                }

            }
            // 保存订单价格信息表 group_order_price
            groupOrder.setOrderPrices(groupOrderPriceList);

            // 保存订单行程信息表 group_route
            groupOrder.setGroupRouteList(groupRouteList);
        }
        httpPost.abort();

        Integer groupOrderId = groupOrderBiz.saveAiYouDataToGroupOrder(groupOrderList);
        if (groupOrderId > 0) {
            return successJson("msg", "数据导入成功！");
        } else {
            return errorJson("数据导入失败！");
        }

    }

    @RequestMapping(value = "toImpAiYouOrder.htm")
    public String toImpAiYouOrder(HttpServletRequest request, Integer productId, String code, String date,
                                  String supplierCode, String aiyouId, Model model) throws Exception {

        model.addAttribute("operType", 1);
        model.addAttribute("editType", true);
        model.addAttribute("config", config);
        List<ProductGroupSupplier> supplierList = productGroupSupplierService.selectProductGroupSuppliers2(productId); // 获取价格下的组团社列表
        model.addAttribute("supplierList", supplierList);
        PlatformEmployeePo curUser = WebUtils.getCurUser(request);
        model.addAttribute("curUser", curUser);
        ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(productId);
        ProductInfo productInfo = productInfoService.findProductInfoById(productId);

		/* 读取团的详细信息 */
        HttpClient httpClient = new DefaultHttpClient();
        String getOrdersUrl = "http://{{ip}}/aiyou/api/erp.do?m=getGroupInfo&code={{supplier_code}}&group_id={{group_id}}"
                .replace("{{ip}}", Constants.aiYouUrlMap.get(supplierCode)).replace("{{supplier_code}}", code)
                .replace("{{group_id}}", aiyouId);

        Map<String, String> params = new HashMap<String, String>();
        params.put("m", "getGroupInfo");
        params.put("code", code);
        params.put("group_id", aiyouId);
        String sign = MD5Util.getSign_Aiyou(code, MD5Util.MD5_Taobao(code + "erp"), params);
        getOrdersUrl += "&sign=" + sign;
        HttpGet getOrders = new HttpGet(getOrdersUrl);
        HttpResponse orders = httpClient.execute(getOrders);
        String r = EntityUtils.toString(orders.getEntity());
        AiYouBean aiYouBean = JSON.parse(r, AiYouBean.class);
        getOrders.abort();

		/* 把数据放到groupOrder里 */
        FitOrderVO vo = new FitOrderVO();
        GroupOrder groupOrder = new GroupOrder();
        groupOrder.setDepartureDate(aiYouBean.getGroup_date());
        groupOrder.setAiyouGroupId(aiyouId);
        groupOrder.setSupplierCode(aiyouId);
        groupOrder.setNumAdult(aiYouBean.getAdult_num());
        groupOrder.setNumChild(aiYouBean.getChild_num());
        groupOrder.setSupplierCode(aiYouBean.getGroup_num());
        groupOrder.setReceiveMode(aiYouBean.getGroup_num().substring(8));
        groupOrder.setDepartureDate(date);
        groupOrder.setProductName(aiYouBean.getProduct_name());
        groupOrder.setContactName(aiYouBean.getReseller_contact_name());
        groupOrder.setContactMobile(aiYouBean.getReseller_contact_mobile());
        groupOrder.setContactFax(aiYouBean.getReseller_fax());
        groupOrder.setContactTel(aiYouBean.getReseller_tel());
        String memo = "";
        if (aiYouBean.getMemo() != null) {
            memo += aiYouBean.getMemo() + "\n";
        }
        memo += "爱游产品名：" + aiYouBean.getProduct_name() + "\n";
        if (aiYouBean.getFlight_info() != null) {
            memo += "机票：" + aiYouBean.getFlight_info() + "\n";
        }
        if (aiYouBean.getRoom_info() != null) {
            memo += "用房：" + aiYouBean.getRoom_info() + "\n";
        }
        groupOrder.setRemarkInternal(memo);

        groupOrder.setOrderType(0);
        groupOrder.setSaleOperatorId(curUser.getEmployeeId());
        groupOrder.setSaleOperatorName(curUser.getName());
        groupOrder.setOperatorId(curUser.getEmployeeId());
        groupOrder.setOperatorName(curUser.getName());
        // supplierService.selectBySupplierId(Constants.supplierMap.get(supplierCode));
        SupplierInfo supplierInfo = supplierService.selectBySupplierId(Constants.supplierMap.get(supplierCode)); // TODO:
        // 先都显示爱游店
        if (supplierInfo != null) {
            groupOrder.setSupplierId(supplierInfo.getId());
            groupOrder.setSupplierName(supplierInfo.getNameFull());
        }

        groupOrder.setProductId(productInfo.getId());
        groupOrder.setProductBrandId(productInfo.getBrandId());
        groupOrder.setProductBrandName(productInfo.getBrandName());
        groupOrder.setProductShortName(productInfo.getNameCity());
        groupOrder.setProductName(productInfo.getNameCity());
        groupOrder.setRemark(productRemark.getRemarkInfo());
        groupOrder.setServiceStandard(productRemark.getServeLevel());

        vo.setGroupOrder(groupOrder);

        Date d = new SimpleDateFormat("yyyy-MM-dd").parse(date);
        int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(), d);
        model.addAttribute("allowNum", count); // 库存
        model.addAttribute("productId", productId);

        List<DicInfo> zjlxList = dicService.getListByTypeCode(BasicConstants.GYXX_ZJLX);
        model.addAttribute("zjlxList", zjlxList);
        List<GroupOrderGuest> groupOrderGuestList = new ArrayList<GroupOrderGuest>();

        List<HashMap<String, String>> tourists = aiYouBean.getTourists();
        if (tourists != null && tourists.size() > 0) {
            GroupOrderGuest gog;
            for (HashMap<String, String> t : tourists) {
                Tourist tourist = new Tourist();
                tourist.setTourist_id(t.get("tourist_id"));
                tourist.setTourist_id_type(t.get("tourist_id_type"));
                tourist.setTourist_mobile(t.get("tourist_mobile"));
                tourist.setTourist_name(t.get("tourist_name"));
                gog = new GroupOrderGuest();
                gog.setName(tourist.getTourist_name());
                gog.setCertificateNum(tourist.getTourist_id());
                gog.setMobile(tourist.getTourist_mobile());
                if ("idcard".equals(tourist.getTourist_id_type())) {
                    gog.setCertificateTypeId(dicService
                            .getDicInfoByTypeCodeAndDicCode(BasicConstants.GYXX_ZJLX, BasicConstants.GYXX_ZJLX_SFZ)
                            .getId());
                } else if ("passport".equals(tourist.getTourist_id_type())) {
                    gog.setCertificateTypeId(dicService
                            .getDicInfoByTypeCodeAndDicCode(BasicConstants.GYXX_ZJLX, BasicConstants.GYXX_ZJLX_HZ)
                            .getId());
                }
                groupOrderGuestList.add(gog);
            }
        }

        vo.setGroupOrderGuestList(groupOrderGuestList);

        int bizId = WebUtils.getCurBizId(request);

        model.addAttribute("vo", vo);
        List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
        model.addAttribute("jdxjList", jdxjList);
        List<DicInfo> jtfsList = dicService.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
        model.addAttribute("jtfsList", jtfsList);

        List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
        model.addAttribute("sourceTypeList", sourceTypeList);
        List<RegionInfo> allProvince = regionService.getAllProvince();
        model.addAttribute("allProvince", allProvince);
        List<DicInfo> lysfxmList = dicService.getListByTypeCode(BasicConstants.GYXX_LYSFXM,
                WebUtils.getCurBizId(request));
        model.addAttribute("lysfxmList", lysfxmList);
        return "aiyou/fitOrderInfo";
    }

    @RequestMapping(value = "saveFitOrderInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveFitOrderInfo(HttpServletRequest request, FitOrderVO fitOrderVO) throws ParseException {
        Integer orderId;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Integer newNum = fitOrderVO.getGroupOrder().getNumAdult() + fitOrderVO.getGroupOrder().getNumChild();
        Integer oldNum = 0;
        try {
            if (fitOrderVO.getGroupOrder().getId() != null) {
                FitOrderVO vo = fitOrderDal.selectFitOrderVOById(fitOrderVO.getGroupOrder().getId());

                oldNum = vo.getGroupOrder().getNumAdult() + vo.getGroupOrder().getNumChild();
            }
            fitOrderVO.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
            ProductInfo productInfo = productInfoService.findProductInfoById(fitOrderVO.getGroupOrder().getProductId());
            orderId = fitOrderDal.saveOrUpdateFitOrderInfo(fitOrderVO, WebUtils.getCurUserId(request),
                    WebUtils.getCurUser(request).getName(), productInfo.getOperatorId(), productInfo.getOperatorName(),
                    WebUtils.getCurBizId(request), settingCommon.getMyBizCode(request), false);
        } catch (ParseException e) {
            return errorJson("操作失败,请检查后重试！");
        }
        try {
            productStockService.updateStockCount(fitOrderVO.getGroupOrder().getProductId(),
                    sdf.parse(fitOrderVO.getGroupOrder().getDepartureDate()), newNum - oldNum);
        } catch (Exception e) {
            return errorJson("更新库存失败！");
        }

        return successJson("orderId", orderId + "");
    }

    /**
     * 根据产品ID和日期获取库存
     *
     * @param date
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "getStockByProductId.do")
    @ResponseBody
    public String getStockByProductId(Integer productId, String date) throws ParseException {
        Integer count = productStockService.getRestCountByProductIdAndDate(productId,
                new SimpleDateFormat("yyyy-MM-dd").parse(date));
        return successJson("count", count.toString());
    }

    @RequestMapping(value = "getProductList.do", method = RequestMethod.GET)
    @ResponseBody
    public String getProductList(HttpServletRequest request, HttpServletResponse reponse, String name, String date)
            throws UnsupportedEncodingException {
        HashMap<String, Object> json = new HashMap<String, Object>();
        if (name == null) {
            name = "";
        }
        name = URLDecoder.decode(name, "UTF-8");

        List<ProductInfo> prodList = productInfoService.searchProductByNameAndDate(WebUtils.getCurBizId(request), name,
                date);

        ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
        for (ProductInfo p : prodList) {
            HashMap<String, String> prodMap = new HashMap<String, String>();
            prodMap.put("label", p.getBrandName() + p.getNameCity());
            prodMap.put("value", p.getId().toString());
            result.add(prodMap);
        }

        json.put("result", result);
        json.put("success", "true");
        return JSONArray.toJSONString(json);
    }

    

}
