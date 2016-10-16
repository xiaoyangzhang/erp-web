<%@ page pageEncoding="UTF-8" %>
<script type="text/html" id="day_template" name-regex="groupRouteDayVOList\[\d]"
        name-result="groupRouteDayVOList[$param]">
    <tr id="tr_day_{{dayNum}}">
        <td>
            <div class="day_num">
                <p class="relative inl-bl"><span class="day_sequence">{{timeByDateCalculate(dayNum)}}</span><span
                        class="day_delete" style="display: none;"></span></p>
 				<input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.id" value="{{id}}" />
                <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.dayNum" value="{{dayNum}}" />
            </div>
        </td>
        <td>
            <div class="traffic_details"></div>
            <p class="mt-30 mb-20"><a href="javascript:void(0)" class="traffic_select def">选择交通</a></p>
        </td>
        <td style="text-align: left;">
            <p class="mt-10 ml-10 mr-10"><textarea name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.routeDesp" class="l_textarea">{{routeDesp}}</textarea>
            </p>

            <div class="mt-10 ml-10 mr-10 mb-10 blue">
                <p class="">温情提示：</p>

                <p class=""><textarea class="l_textarea"
                        name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.routeTip">{{routeTip}}</textarea></p>
            </div>

        </td>
        <td>
            <p class="mt-5"><label>早餐 <input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd w-60" style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  id="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.breakfast"
                                             type="text"
                                             name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.breakfast"
                                             value="{{breakfast}}"/></label></p>

            <p class="mt-5"><label>午餐 <input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd w-60" style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  id="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.lunch" type="text"
                                             name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.lunch"
                                             value="{{lunch}}"/></label></p>

            <p class="mt-5"><label>晚餐 <input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd w-60" style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  id="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.supper" type="text"
                                             name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.supper"
                                             value="{{supper}}"/></label></p>

            <p class="mt-5"><label>住宿 <input id="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.hotelName"
                                             type="text"
                                             name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.hotelName"
                                             value="{{hotelName}}"
                                             class="w-60"/></label></p>
            <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRoute.hotelId" value="0"/>
        </td>
        <td>
            <div class="scenicBtns supplier_details">
            </div>
            <p class="mt-30 mb-20"><a href="javascript:void(0)" class="supplier_select def">选择商家</a></p>
        </td>
        <td>
            <div class="td_img" id="divImgset">
                <div class="img_details">

                </div>
                <label class="img_select ulImgBtn"></label>
            </div>
        </td>
    </tr>
</script>
<script type="text/html" id="traffic_template" name-regex="groupRouteTrafficList\[\d]"
        name-result="groupRouteTrafficList[$param]">
    <span class="traffic_span button_con mt-5">
		<input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].id" value="{{id}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].typeId"
               value="{{typeId}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].typeName"
               value="{{typeName}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].cityDeparture"
               value="{{cityDeparture}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].cityArrival"
               value="{{cityArrival}}"/>
        <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].miles"
               value="{{miles}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteTrafficList[{{trafficIndex}}].duration"
               value="{{duration}}"/>
        <span class="mt-20"><label class="diqu_txt">{{cityDeparture}}</label><img src="{{trafficImgPath}}"
                                                                                  class="city_img"/><label
                class="diqu_txt">{{cityArrival}}</label></span>
        <br />
        <span class="mt-10"><label>{{trafficContent}}</label></span>
        <span class="icon_delete traffic_delete" style="display: none;"></span>
    </span>
</script>
<script type="text/html" id="supplier_template" name-regex="groupRouteOptionsSupplierList\[\d]"
        name-result="groupRouteOptionsSupplierList[$param]">
    <p class="supplier_span">
 		<input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteOptionsSupplierList[{{supplierIndex}}].id" value="{{id}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteOptionsSupplierList[{{supplierIndex}}].supplierId"
               value="{{supplierId}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteOptionsSupplierList[{{supplierIndex}}].supplierType"
               value="{{supplierType}}"/>
        <input type="hidden"
               name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteOptionsSupplierList[{{supplierIndex}}].supplierName"
               value="{{supplierName}}"/>
        <span class="button_con mt-5"><label
                class="btn_val">{{supplierTypeName}}&nbsp;&nbsp;{{supplierName}}</label><span
                class="supplier_delete icon_delete" style="display: none;"></span></span>
    </p>
</script>
<script type="text/html" id="img_template" name-regex="groupRouteAttachmentList\[\d]"
        name-result="groupRouteAttachmentList[$param]">
    <span class="ulImg img_span">
        <img src="{{imgSrc}}" alt="$name"><i class="img_delete icon_del" style="display: none;"></i>
		<input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteAttachmentList[{{imgIndex}}].id"
               value="{{id}}"/>
        <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteAttachmentList[{{imgIndex}}].name"
               value="{{imgName}}"/>
        <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteAttachmentList[{{imgIndex}}].path"
               value="{{imgPath}}"/>
        <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteAttachmentList[{{imgIndex}}].type"
               value="1"/>
        <input type="hidden" name="groupRouteDayVOList[{{dayNum - 1}}].groupRouteAttachmentList[{{imgIndex}}].objType"
               value="2"/>
    </span>
</script>