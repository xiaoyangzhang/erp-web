<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>团信息</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="/WEB-INF/include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/quality/quality.css"/>
</head>
<body>
     <div class="p_container" >
	    <div class="p_container_sub">
	    	<p class="p_paragraph_title"><b>团组信息</b></p>
            <dl class="p_paragraph_content">
            	<dd>
            		<div class="dd_left"><b>团号：</b></div>
            		<div class="dd_right">${group.groupCode }</div>
            		<div class="clear"></div>
            	</dd>
            	<dd>
            		<div class="dd_left"><b>团类别：</b></div>
            		<div class="dd_right"><c:if test="${group.groupMode==0 }">散客</c:if><c:if test="${group.groupMode>0 }">团队</c:if></div>
            		<div class="clear"></div>
            	</dd>
            	<dd>
            		<div class="dd_left"><b>产品名称：</b></div>
            		<div class="dd_right">【${group.productBrandName }】${group.productName }</div>
            		<div class="clear"></div>
            	</dd>
            	<dd>
            		<div class="dd_left"><b>人数：</b></div>
            		<div class="dd_right">${group.totalAdult+group.totalChild+group.totalGuide }人</div>
            		<div class="clear"></div>
            	</dd>
            	<dd>
            		<div class="dd_left"><b>出团日期：</b></div>
            		<div class="dd_right"><fmt:formatDate value="${group.dateStart }" pattern="yyyy-MM-dd"/></div>
            		<div class="clear"></div>
            	</dd>
            </dl>
	    	<p class="p_paragraph_title"><b>旅游评议表</b></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd style="text-align: center;">
	    			<b>团平均得分:</b>
	    			<b class="grade"><fmt:formatNumber value="${groupStaticsVo.score }" type="number" pattern="0.#"/> 分</b>	    			
	    		</dd>
	    		<dd class="pingjia">
            		<div class="dd_left"><b>服务态度：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">    
            				<c:if test="${ groupStaticsVo!=null and groupStaticsVo.guideAttitude!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.guideAttitude>0 and groupStaticsVo.guideAttitude<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude>1 and groupStaticsVo.guideAttitude<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude>2 and groupStaticsVo.guideAttitude<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude>3 and groupStaticsVo.guideAttitude<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude>4 and groupStaticsVo.guideAttitude<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.guideAttitude==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.guideAttitude }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>讲解水平：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.guideProfession!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.guideProfession>0 and groupStaticsVo.guideProfession<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession>1 and groupStaticsVo.guideProfession<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideAttitude==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession>2 and groupStaticsVo.guideProfession<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession>3 and groupStaticsVo.guideProfession<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession>4 and groupStaticsVo.guideProfession<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.guideProfession==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.guideProfession==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.guideProfession }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>用餐质量：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.foodQuality!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.foodQuality>0 and groupStaticsVo.foodQuality<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality>1 and groupStaticsVo.foodQuality<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality>2 and groupStaticsVo.foodQuality<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality>3 and groupStaticsVo.foodQuality<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality>4 and groupStaticsVo.foodQuality<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodQuality==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.foodQuality==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.foodQuality }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>用餐环境：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.foodEnvironment!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.foodEnvironment>0 and groupStaticsVo.foodEnvironment<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment>1 and groupStaticsVo.foodEnvironment<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment>2 and groupStaticsVo.foodEnvironment<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment>3 and groupStaticsVo.foodEnvironment<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment>4 and groupStaticsVo.foodEnvironment<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.foodEnvironment==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.foodEnvironment==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.foodEnvironment }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>住宿质量：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.hotelQuality!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.hotelQuality>0 and groupStaticsVo.hotelQuality<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality>1 and groupStaticsVo.hotelQuality<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality>2 and groupStaticsVo.hotelQuality<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality>3 and groupStaticsVo.hotelQuality<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality>4 and groupStaticsVo.hotelQuality<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelQuality==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.hotelQuality==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.hotelQuality }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>住宿环境：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.hotelEnvironment!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment>0 and groupStaticsVo.hotelEnvironment<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment>1 and groupStaticsVo.hotelEnvironment<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment>2 and groupStaticsVo.hotelEnvironment<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment>3 and groupStaticsVo.hotelEnvironment<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment>4 and groupStaticsVo.hotelEnvironment<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.hotelEnvironment==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.hotelEnvironment==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.hotelEnvironment }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>司机态度：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.driverAttitude!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.driverAttitude>0 and groupStaticsVo.driverAttitude<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude>1 and groupStaticsVo.driverAttitude<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude>2 and groupStaticsVo.driverAttitude<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude>3 and groupStaticsVo.driverAttitude<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude>4 and groupStaticsVo.driverAttitude<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverAttitude==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.driverAttitude==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.driverAttitude }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>车容车貌：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.driverEnvironment!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.driverEnvironment>0 and groupStaticsVo.driverEnvironment<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment>1 and groupStaticsVo.driverEnvironment<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment>2 and groupStaticsVo.driverEnvironment<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment>3 and groupStaticsVo.driverEnvironment<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment>4 and groupStaticsVo.driverEnvironment<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.driverEnvironment==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.driverEnvironment==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.driverEnvironment }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<dd class="pingjia">
            		<div class="dd_left"><b>景点满意度：</b></div>
            		<div class="dd_right">
            			<div class="inl-bl">           				
	            			<c:if test="${ groupStaticsVo!=null and groupStaticsVo.scenicWhole!=null }">
	            				<c:choose>
	            					<c:when test="${ groupStaticsVo.scenicWhole>0 and groupStaticsVo.scenicWhole<1 }">
	            						<div class="xx-star xx-05"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole==1 }">
	            						<div class="xx-star xx-10"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole>1 and groupStaticsVo.scenicWhole<2 }">
	            						<div class="xx-star xx-15"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole==2 }">
	            						<div class="xx-star xx-20"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole>2 and groupStaticsVo.scenicWhole<3 }">
	            						<div class="xx-star xx-25"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole==3 }">
	            						<div class="xx-star xx-30"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole>3 and groupStaticsVo.scenicWhole<4 }">
	            						<div class="xx-star xx-35"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole==4 }">
	            						<div class="xx-star xx-40"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole>4 and groupStaticsVo.scenicWhole<5 }">
	            						<div class="xx-star xx-45"></div>
	            					</c:when>
	            					<c:when test="${ groupStaticsVo.scenicWhole==5 }">
	            						<div class="xx-star xx-50"></div>
	            					</c:when>
	            					<c:otherwise>
	            						<div class="xx-star xx-00"></div>
	            					</c:otherwise>
	            				</c:choose>            				
            				</c:if>       		
	            			<c:if test="${ groupStaticsVo==null or groupStaticsVo.scenicWhole==null }">
	            				<div class="xx-star xx-00"></div>
	            			</c:if>
            			</div>
            			<div class="inl-bl grade">
            				<b><fmt:formatNumber value="${groupStaticsVo.scenicWhole }" type="number" pattern="0.#"/>分</b>
            			</div>
            		</div>
            		<div class="clear"></div>
            	</dd>
            	<div class="clear"></div>
	    		<dd>
	    			<div class="pl-10 pr-10">
	    				<table border="1" cellspacing="0" cellpadding="0" class="w_table">
	    					<col width="5%"/><col width="10%"/><col width=""/><col width="10%"/><col width="10%"/>
	    					<col width="10%"/><col width="20%"/><col width="10%"/>
	    					<thead>
	    						<th>序号</th>
	    						<th>订单号</th>
	    						<th>组团社</th>
	    						<th>客人姓名</th>
	    						<th>联系电话</th>
	    						<th>评分情况</th>
	    						<th>意见和建议</th>
	    						<th>操作</th>
	    					</thead>
	    					<c:forEach var="statics" items="${guestFeedbackStaticsList }">
		    					<tr>
		    						<td>1</td>
		    						<td>${statics.orderNo }</td>
		    						<td>${statics.supplierName }</td>
		    						<td>${statics.guestName }</td>
		    						<td>${statics.mobile }</td>
		    						<td><a href="javascript:void" onclick="showTip(this)" title="综合评分：<fmt:formatNumber value="${statics.score }" type="number" pattern="0.#"/>" guideAttitude="${statics.guideAttitude }" guideProfession="${statics.guideProfession }" foodQuality="${statics.foodQuality }" foodEnvironment="${statics.foodEnvironment }" hotelQuality="${statics.hotelQuality }" hotelEnvironment="${statics.hotelEnvironment }" driverAttitude="${statics.driverAttitude }" driverEnvironment="${statics.driverEnvironment }" scenicWhole="${statics.scenicWhole }"><fmt:formatNumber value="${statics.score }" type="number" pattern="0.#"/></a></td>
		    						<td style="text-align:left;">${statics.suggest }</td>
		    						<td><a href="####" class="def">查看</a></td>
		    					</tr>
	    					</c:forEach>	    					
	    				</table>
	    			</div>
	    		</dd>	    		
	    	</dl>
	    	
			<p class="p_paragraph_title"><b>客人标签</b></p>
	    	<dl class="p_paragraph_content">
	    		<div class="interest">
	    			<p class="">兴趣</p>
	    			<ul class="border-r">
	    				<li class="bg-999">美食(12)</li>
	    				<li class="bg-09f">美景(12)</li>
	    				<li class="bg-6c6">美景(12)</li>
	    				<li class="bg-0cf">美景(12)</li>
	    				<li class="bg-f66">美景(12)</li>
	    				<li class="bg-fc6">美景(12)</li>
	    				<li class="bg-999">美食(12)</li>
	    				<li class="bg-09f">美景(12)</li>
	    				<li class="bg-6c6">美景(12)</li>
	    				<li class="bg-0cf">美景(12)</li>
	    				<li class="bg-f66">美景(12)</li>
	    				<li class="bg-fc6">美景(12)</li>
	    			</ul>
	    		</div>
	    		<div class="interest">
	    			<p>职业</p>
	    			<ul>
	    				<li class="bg-999">国企(12)</li>
	    				<li class="bg-09f">金融(12)</li>
	    				<li class="bg-6c6">IT(12)</li>
	    				<li class="bg-0cf">大学生(12)</li>
	    				<li class="bg-f66">媒体(12)</li>
	    				<li class="bg-fc6">餐饮(12)</li>

	    			</ul>
	    		</div>
	    		<div class="clear"></div>
	    	</dl>
	    	
			<p class="p_paragraph_title"><b>商家评论</b></p>
            <dl class="p_paragraph_content">
            	<dd>
            		<div class="pl-10 pr-10">
            			<table border="" cellspacing="0" cellpadding="0" class="w_table">
            				<col width="5%"/><col width="15%"/><col width=""/><col width="15%"/>
            				<col width="15%"/><col width="15%"/>
            				<thead>
            					<th>序号</th>
            					<th>类别</th>
            					<th>商家</th>
            					<th>评论数</th>
            					<th>阅读次数</th>
            					<th>操作</th>
            				</thead>
            				<tr>
            					<td>1</td>
            					<td>景点</td>
            					<td>七彩云南</td>
            					<td>10</td>
            					<td>2000</td>
            					<td><a href="####" class="def">查看</a></td>
            				</tr>
            				<tr>
            					<td>1</td>
            					<td>景点</td>
            					<td>七彩云南</td>
            					<td>10</td>
            					<td>2000</td>
            					<td><a href="####" class="def">查看</a></td>
            				</tr>
            			</table>
            		</div>
            	</dd>
            </dl>
            
            <p class="p_paragraph_title"><b>导游评论</b></p>
            <dl class="p_paragraph_content">
            	<dd>
            		<div class="pl-10 pr-10">
            			<table border="" cellspacing="0" cellpadding="0" class="w_table">
            				<col width="5%"/><col width="15%"/><col width=""/><col width="15%"/>
            				<col width="15%"/><col width="15%"/>
            				<thead>
            					<th>序号</th>
            					<th>导游姓名</th>
            					<th>评分</th>
            					<th>评论数</th>
            					<th>操作</th>
            				</thead>
            				<tr>
            					<td>1</td>
            					<td>张三</td>
            					<td>5</td>
            					<td>12</td>
            					<td><a href="####" class="def">查看</a></td>
            				</tr>
            				<tr>
            					<td>2</td>
            					<td>李四</td>
            					<td>5</td>
            					<td>12</td>
            					<td><a href="####" class="def">查看</a></td>
            				</tr>
            			</table>
            		</div>
            	</dd>
            </dl>
            
            <div class="btn-box mb-30">
            	<button class="button button-rounded button-small">关闭</button>
            </div>
        </div>
       
    </div>
</body>
</html>
