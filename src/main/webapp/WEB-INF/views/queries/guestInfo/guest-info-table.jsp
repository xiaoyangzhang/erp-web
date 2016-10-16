<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客人信息统计</title>
</head>
<body>
<table style="border: 0px;" width="100%">
<tbody>
<tr  ><td width="40%" >
<div id="containerSex" >
	
</div></td>
<td width="40%">
<div id="containerAge" >
	
</div></td>
</tr>
<tr><td width="50%">
 <div id="containerAir" >
	
</div></td><td width="50%">
 <div id="containerSource" >
	
</div> </td>
</tr>
</tbody>
</table>
</body>
</html>
<script type="text/javascript">
$(function () {	
    $('#containerSex').highcharts({
    	chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '男女比例'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}：{point.y}人'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '比例',
            data: [
                ${jsonSexStr}
            ]
        }]
    });
    $('#containerAge').highcharts({
    	chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '年龄段'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}：{point.y}人'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '比例',
            data: [
                ${jsonAgeStr}
            ]
        }]
    });
    $('#containerAir').highcharts({
    	chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '航班起飞时间'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}：{point.y}人'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '比例',
            data: [
                ${jsonAirStr}
            ]
        }]
    });
    $('#containerSource').highcharts({
    	chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: '客源地'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}：{point.y}人'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '比例',
            data: [
                ${jsonSourceStr}
            ]
        }]
    });
});	
</script>