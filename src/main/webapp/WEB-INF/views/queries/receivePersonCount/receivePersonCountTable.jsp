<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<div id="container" style="width:100%;height:50%;">
	
</div>
<script>
$(function () {
    $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '接待人数统计'
        },
        xAxis: {
            categories: ['1月', '2月', '3月', '4月', '5月','6月', '7月', '8月', '9月', '10月','11月', '12月'],
            labels:{
            	style:{
            
            	color: '#6D869F'
            }
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: '人数'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            x: -70,
            verticalAlign: 'top',
            y: 20,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.x +'</b><br/>'+
                    this.series.name +': '+ this.y +'<br/>'+
                    '合计: '+ this.point.stackTotal;
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: ('red') || 'white',
                    y:-9
                }
            }
            
        },
        series: [{
            name: '团队',
            data: [${personMap['group1Total']},${personMap['group2Total']},${personMap['group3Total']},${personMap['group4Total']},${personMap['group5Total']},${personMap['group6Total']},
                   ${personMap['group7Total']},${personMap['group8Total']},${personMap['group9Total']},
            	${personMap['group10Total']},${personMap['group11Total']},${personMap['group12Total']}],
            	 color: '#F8A920'
        }, {
            name: '散客',
            data: [${personMap['disperse1Total']},${personMap['disperse2Total']},${personMap['disperse3Total']},${personMap['disperse4Total']},${personMap['disperse5Total']},
            	${personMap['disperse6Total']},${personMap['disperse7Total']},${personMap['disperse8Total']},${personMap['disperse9Total']},
                	   ${personMap['disperse10Total']},${personMap['disperse11Total']},${personMap['disperse12Total']}],
               	color: '#65FC3B'
        },]
    });
});
</script>
 <table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th rowspan="2">月份<i class="w_table_split"></i></th>
			<th colspan="3" >团队人数<i class="w_table_split"></i></th>
			<th colspan="3" >散客人数<i class="w_table_split"></i></th>
			<th colspan="3" >合计<i class="w_table_split"></i></th>
			
		</tr>
		<tr>
			<th>成人</th>
			<th>儿童</th>
			<th>全陪</th>
			<th>成人</th>
			<th>儿童</th>
			<th>全陪</th>
			<th>成人</th>
			<th>儿童</th>
			<th>全陪</th>
		</tr>
		
	</thead>
	<tbody>
			<tr>
				<td>1月</td>
				<td>${personMap.group1Adult }</td>
				<td>${personMap.group1child }</td>
				<td>${personMap.group1Guide }</td>
				<td>${personMap.disperse1Adult }</td>
				<td>${personMap.disperse1child }</td>
				<td>${personMap.disperse1Guide }</td>
				<td>${personMap.group1Adult+personMap.disperse1Adult}</td>
				<td>${personMap.group1child+personMap.disperse1child }</td>
				<td>${personMap.group1Guide+personMap.disperse1Guide}</td>
				
			</tr>
			<tr>
				<td>2月</td>
				<td>${personMap.group2Adult }</td>
				<td>${personMap.group2child }</td>
				<td>${personMap.group2Guide }</td>
				<td>${personMap.disperse2Adult }</td>
				<td>${personMap.disperse2child }</td>
				<td>${personMap.disperse2Guide }</td>
				<td>${personMap.group2Adult+personMap.disperse2Adult}</td>
				<td>${personMap.group2child+personMap.disperse2child }</td>
				<td>${personMap.group2Guide+personMap.disperse2Guide}</td>
				
			</tr>
			<tr>
				<td>3月</td>
				<td>${personMap.group3Adult }</td>
				<td>${personMap.group3child }</td>
				<td>${personMap.group3Guide }</td>
				<td>${personMap.disperse3Adult }</td>
				<td>${personMap.disperse3child }</td>
				<td>${personMap.disperse3Guide }</td>
				<td>${personMap.group3Adult+personMap.disperse3Adult}</td>
				<td>${personMap.group3child+personMap.disperse3child }</td>
				<td>${personMap.group3Guide+personMap.disperse3Guide}</td>
				
			</tr>
			<tr>
				<td>4月</td>
				<td>${personMap.group4Adult }</td>
				<td>${personMap.group4child }</td>
				<td>${personMap.group4Guide }</td>
				<td>${personMap.disperse4Adult }</td>
				<td>${personMap.disperse4child }</td>
				<td>${personMap.disperse4Guide }</td>
				<td>${personMap.group4Adult+personMap.disperse4Adult}</td>
				<td>${personMap.group4child+personMap.disperse4child }</td>
				<td>${personMap.group4Guide+personMap.disperse4Guide}</td>
				
			</tr>
			<tr>
				<td>5月</td>
				<td>${personMap.group5Adult }</td>
				<td>${personMap.group5child }</td>
				<td>${personMap.group5Guide }</td>
				<td>${personMap.disperse5Adult }</td>
				<td>${personMap.disperse5child }</td>
				<td>${personMap.disperse5Guide }</td>
				<td>${personMap.group5Adult+personMap.disperse5Adult}</td>
				<td>${personMap.group5child+personMap.disperse5child }</td>
				<td>${personMap.group5Guide+personMap.disperse5Guide}</td>
				
			</tr>
			<tr>
				<td>6月</td>
				<td>${personMap.group6Adult }</td>
				<td>${personMap.group6child }</td>
				<td>${personMap.group6Guide }</td>
				<td>${personMap.disperse6Adult }</td>
				<td>${personMap.disperse6child }</td>
				<td>${personMap.disperse6Guide }</td>
				<td>${personMap.group6Adult+personMap.disperse6Adult}</td>
				<td>${personMap.group6child+personMap.disperse6child }</td>
				<td>${personMap.group6Guide+personMap.disperse6Guide}</td>
				
			</tr>
			<tr>
				<td>7月</td>
				<td>${personMap.group7Adult }</td>
				<td>${personMap.group7child }</td>
				<td>${personMap.group7Guide }</td>
				<td>${personMap.disperse7Adult }</td>
				<td>${personMap.disperse7child }</td>
				<td>${personMap.disperse7Guide }</td>
				<td>${personMap.group7Adult+personMap.disperse7Adult}</td>
				<td>${personMap.group7child+personMap.disperse7child }</td>
				<td>${personMap.group7Guide+personMap.disperse7Guide}</td>
				
			</tr>
			<tr>
				<td>8月</td>
				<td>${personMap.group8Adult }</td>
				<td>${personMap.group8child }</td>
				<td>${personMap.group8Guide }</td>
				<td>${personMap.disperse8Adult }</td>
				<td>${personMap.disperse8child }</td>
				<td>${personMap.disperse8Guide }</td>
				<td>${personMap.group8Adult+personMap.disperse8Adult}</td>
				<td>${personMap.group8child+personMap.disperse8child }</td>
				<td>${personMap.group8Guide+personMap.disperse8Guide}</td>
				
			</tr>
			<tr>
				<td>9月</td>
				<td>${personMap.group9Adult }</td>
				<td>${personMap.group9child }</td>
				<td>${personMap.group9Guide }</td>
				<td>${personMap.disperse9Adult }</td>
				<td>${personMap.disperse9child }</td>
				<td>${personMap.disperse9Guide }</td>
				<td>${personMap.group9Adult+personMap.disperse9Adult}</td>
				<td>${personMap.group9child+personMap.disperse9child }</td>
				<td>${personMap.group9Guide+personMap.disperse9Guide}</td>
			</tr>
			<tr>
				<td>10月</td>
				<td>${personMap.group10Adult }</td>
				<td>${personMap.group10child }</td>
				<td>${personMap.group10Guide }</td>
				<td>${personMap.disperse10Adult }</td>
				<td>${personMap.disperse10child }</td>
				<td>${personMap.disperse10Guide }</td>
				<td>${personMap.group10Adult+personMap.disperse10Adult}</td>
				<td>${personMap.group10child+personMap.disperse10child }</td>
				<td>${personMap.group10Guide+personMap.disperse10Guide}</td>
				
			</tr>
			<tr>
				<td>11月</td>
				<td>${personMap.group11Adult }</td>
				<td>${personMap.group11child }</td>
				<td>${personMap.group11Guide }</td>
				<td>${personMap.disperse11Adult }</td>
				<td>${personMap.disperse11child }</td>
				<td>${personMap.disperse11Guide }</td>
				<td>${personMap.group11Adult+personMap.disperse11Adult}</td>
				<td>${personMap.group11child+personMap.disperse11child }</td>
				<td>${personMap.group11Guide+personMap.disperse11Guide}</td>
				
			</tr>
			<tr>
				<td>12月</td>
				<td>${personMap.group12Adult }</td>
				<td>${personMap.group12child }</td>
				<td>${personMap.group12Guide }</td>
				<td>${personMap.disperse12Adult }</td>
				<td>${personMap.disperse12child }</td>
				<td>${personMap.disperse12Guide }</td>
				<td>${personMap.group12Adult+personMap.disperse12Adult}</td>
				<td>${personMap.group12child+personMap.disperse12child }</td>
				<td>${personMap.group12Guide+personMap.disperse12Guide}</td>
				
			</tr>
		<tr>
			<td>合计：</td>
			<td><fmt:formatNumber value="${personMap.groupTotalAdult }" pattern="#" type="number"/></td>
			<td>${personMap.groupTotalChild }</td>
			<td>${personMap.groupTotalGuide }</td>
			<td><fmt:formatNumber value="${personMap.disperseTotalAdult }" pattern="#" type="number"/></td>
			<td>${personMap.disperseTotalChild }</td>
			<td>${personMap.disperseTotalGuide }</td>
			<td><fmt:formatNumber value="${personMap.groupTotalAdult+personMap.disperseTotalAdult }" pattern="#" type="number"/></td>
			<td>${personMap.groupTotalChild+personMap.disperseTotalChild }</td>
			<td>${personMap.groupTotalGuide+personMap.disperseTotalGuide }</td>
		</tr>
		<tr>
			<td>比例：</td>
			<td colspan="3"><fmt:formatNumber value="${(personMap.groupTotalAdult+personMap.groupTotalChild+personMap.groupTotalGuide+personMap.disperseTotalChild+personMap.disperseTotalAdult+personMap.disperseTotalGuide=='0.00')
			?0:(personMap.groupTotalAdult+personMap.groupTotalChild+personMap.groupTotalGuide)*100/
			(personMap.groupTotalAdult+personMap.groupTotalChild+personMap.groupTotalGuide+personMap.disperseTotalChild+personMap.disperseTotalAdult+personMap.disperseTotalGuide) }" 
			pattern="#.##" type="number"/>%</td>
			<td colspan="3">
			<fmt:formatNumber value="${(personMap.groupTotalAdult+personMap.groupTotalChild+personMap.groupTotalGuide+personMap.disperseTotalChild+personMap.disperseTotalAdult+personMap.disperseTotalGuide=='0.00')
			?0:(personMap.disperseTotalAdult+personMap.disperseTotalChild+personMap.disperseTotalGuide)*100/
			(personMap.groupTotalAdult+personMap.groupTotalChild+personMap.groupTotalGuide+personMap.disperseTotalChild+personMap.disperseTotalAdult+personMap.disperseTotalGuide) }" 
			pattern="#.##" type="number"/>%</td>
			<td colspan="3"></td>
			
		</tr>
	</tbody>
</table>
 
<%-- <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include> --%>
