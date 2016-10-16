<%@ page pageEncoding="UTF-8" %>
<script type="text/html" id="day_template" name-regex="productRoteDayVoList\[\d]"
        name-result="productRoteDayVoList[$param]">
    <tr id="tr_day_{{dayNum}}">
        <td>
            <div class="day_num">
                <p class="relative inl-bl"><span class="day_sequence">第{{dayNum}}天</span><span
                        class="day_delete" style="display: none;"></span></p>
                <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productRoute.dayNum" value="{{dayNum}}" />
            </div>
        </td>
        <td>
            <div class="traffic_details"></div>
            <p class="mt-30 mb-20"><a href="javascript:void(0)" class="traffic_select def">选择交通</a></p>
        </td>
        <td style="text-align: left;">
            <div  class="mt-10 ml-10 mr-10 mb-10 blue">
                <p class="">简短行程：</p>

                <p class=""><textarea style="height: 30px;" name="productRoteDayVoList[{{dayNum - 1}}].productRoute.routeShort">{{routeShort}}</textarea></p>
            </div>
			<div class="mt-10 ml-10 mr-10 mb-10 blue">
                <p class="">详细行程：</p>

                <p class=""><textarea name="productRoteDayVoList[{{dayNum - 1}}].productRoute.routeDesp">{{routeDesp}}</textarea></p>
            </div>
			
            <div class="mt-10 ml-10 mr-10 mb-10 blue">
                <p class="">温情提示：</p>

                <p class=""><textarea style="height: 30px;" name="productRoteDayVoList[{{dayNum - 1}}].productRoute.routeTip">{{routeTip}}</textarea></p>
            </div>

        </td>
        <td>
            <p class="mt-5"><label>早餐 <input style="width:60px; cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd" id="productRoteDayVoList[{{dayNum - 1}}].productRoute.breakfast"
                                             type="text"
                                             name="productRoteDayVoList[{{dayNum - 1}}].productRoute.breakfast"
                                             value="{{breakfast}}"
                                             class="w-60"/></label></p>

            <p class="mt-5"><label>午餐 <input style="width:60px; cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd" id="productRoteDayVoList[{{dayNum - 1}}].productRoute.lunch" type="text"
                                             name="productRoteDayVoList[{{dayNum - 1}}].productRoute.lunch"
                                             value="{{lunch}}"
                                             class="w-60"/></label></p>

            <p class="mt-5"><label>晚餐 <input style="width:60px; cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList(this);"  class="bldd" id="productRoteDayVoList[{{dayNum - 1}}].productRoute.supper" type="text"
                                             name="productRoteDayVoList[{{dayNum - 1}}].productRoute.supper"
                                             value="{{supper}}"
                                             class="w-60"/></label></p>

            <p class="mt-5"><label>住宿 <input id="productRoteDayVoList[{{dayNum - 1}}].productRoute.hotelName"
                                             type="text"
                                             name="productRoteDayVoList[{{dayNum - 1}}].productRoute.hotelName"
                                             value="{{hotelName}}"
                                             class="w-60"/></label></p>
            <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productRoute.hotelId" value="0"/>
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
<script type="text/html" id="traffic_template" name-regex="productRouteTrafficList\[\d]"
        name-result="productRouteTrafficList[$param]">
    <span class="traffic_span button_con mt-5">
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].typeId"
               value="{{typeId}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].typeName"
               value="{{typeName}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].cityDeparture"
               value="{{cityDeparture}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].cityArrival"
               value="{{cityArrival}}"/>
        <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].miles"
               value="{{miles}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productRouteTrafficList[{{trafficIndex}}].duration"
               value="{{duration}}"/>
        <span class="mt-20"><label class="diqu_txt">{{cityDeparture}}</label><img src="{{trafficImgPath}}"
                                                                                  class="city_img"/><label
                class="diqu_txt">{{cityArrival}}</label></span>
        <br />
        <span class="mt-10"><label>{{trafficContent}}</label></span>
        <span class="icon_delete traffic_delete" style="display: none;"></span>
    </span>
</script>
<script type="text/html" id="supplier_template" name-regex="productOptionsSupplierList\[\d]"
        name-result="productOptionsSupplierList[$param]">
    <p class="supplier_span">
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productOptionsSupplierList[{{supplierIndex}}].supplierId"
               value="{{supplierId}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productOptionsSupplierList[{{supplierIndex}}].supplierType"
               value="{{supplierType}}"/>
        <input type="hidden"
               name="productRoteDayVoList[{{dayNum - 1}}].productOptionsSupplierList[{{supplierIndex}}].supplierName"
               value="{{supplierName}}"/>
        <span class="button_con mt-5"><label
                class="btn_val">{{supplierTypeName}}&nbsp;&nbsp;{{supplierName}}</label><span
                class="supplier_delete icon_delete" style="display: none;"></span></span>
    </p>
</script>
<script type="text/html" id="img_template" name-regex="productAttachments\[\d]"
        name-result="productAttachments[$param]">
    <span class="ulImg img_span">
        <img src="{{imgSrc}}" alt="$name"><i class="img_delete icon_del" style="display: none;"></i>
        <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productAttachments[{{imgIndex}}].name"
               value="{{imgName}}"/>
        <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productAttachments[{{imgIndex}}].path"
               value="{{imgPath}}"/>
        <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productAttachments[{{imgIndex}}].type"
               value="1"/>
        <input type="hidden" name="productRoteDayVoList[{{dayNum - 1}}].productAttachments[{{imgIndex}}].objType"
               value="2"/>
    </span>
</script>